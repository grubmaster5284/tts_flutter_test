import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tts_flutter_test/audio_playback/application/state/audio_playback_state.dart';
import 'package:tts_flutter_test/core/utils/logger.dart';

/// [StateNotifier] for managing audio playback state and operations
/// 
/// This class extends `StateNotifier<AudioPlaybackState>` and serves as the business logic layer
/// for audio playback. It manages:
/// - Audio player lifecycle (initialization, disposal)
/// - Playback operations (play, pause, stop, seek)
/// - Audio source loading (URLs and local files)
/// - Volume and playback speed controls
/// - State synchronization with the underlying AudioPlayer
/// 
/// The StateNotifier pattern allows reactive state management where widgets automatically
/// rebuild when the state changes. This is part of the Application layer in clean architecture.
class AudioPlaybackNotifier extends StateNotifier<AudioPlaybackState> {
  AudioPlaybackNotifier() : super(AudioPlaybackState.initial()) {
    _initAudioPlayer();
  }

  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _positionTimer;
  StreamSubscription<Duration>? _positionSubscription;
  StreamSubscription<Duration>? _durationSubscription;
  StreamSubscription<PlayerState>? _playerStateSubscription;

  void _initAudioPlayer() {
    AppLogger.debug('Initializing audio player', tag: 'AudioPlayer');
    
    // Listen to position updates
    _positionSubscription = _audioPlayer.onPositionChanged.listen((position) {
      updatePosition(position.inMilliseconds);
    });

    // Listen to duration updates
    _durationSubscription = _audioPlayer.onDurationChanged.listen((duration) {
      AppLogger.verbose('Duration updated', tag: 'AudioPlayer', data: {'duration': duration.inMilliseconds});
      updateDuration(duration.inMilliseconds);
    });

    // Listen to player state changes
    _playerStateSubscription = _audioPlayer.onPlayerStateChanged.listen((playerState) {
      AppLogger.debug('Player state changed', tag: 'AudioPlayer', data: {'state': playerState.toString()});
      
      switch (playerState) {
        case PlayerState.playing:
          state = state.copyWith(status: PlaybackStatus.playing);
          break;
        case PlayerState.paused:
          state = state.copyWith(status: PlaybackStatus.paused);
          break;
        case PlayerState.stopped:
          state = state.copyWith(status: PlaybackStatus.stopped);
          break;
        case PlayerState.completed:
          AppLogger.info('Audio playback completed', tag: 'AudioPlayer');
          state = state.copyWith(
            status: PlaybackStatus.stopped,
            position: state.duration,
          );
          break;
        case PlayerState.disposed:
          AppLogger.warning('Audio player disposed', tag: 'AudioPlayer');
          break;
      }
    });

    // Set initial volume and playback speed
    _audioPlayer.setVolume(state.volume);
    _audioPlayer.setPlaybackRate(state.playbackSpeed);
    
    AppLogger.debug('Audio player initialized', tag: 'AudioPlayer', data: {
      'volume': state.volume,
      'speed': state.playbackSpeed,
    });
  }

  @override
  void dispose() {
    _positionTimer?.cancel();
    _positionSubscription?.cancel();
    _durationSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  /// Load audio from a source (URL or file path)
  Future<void> loadAudio(String audioSource) async {
    AppLogger.info('Loading audio', tag: 'AudioPlayer', data: {'source': audioSource});
    
    state = state.copyWith(
      status: PlaybackStatus.loading,
      audioSource: audioSource,
      errorMessage: null,
      position: 0,
      duration: 0,
    );

    try {
      // Stop current playback if any
      AppLogger.debug('Stopping current playback', tag: 'AudioPlayer');
      await _audioPlayer.stop();
      
      // Determine if it's a URL or local file path
      final bool isUrl = audioSource.startsWith('http://') || 
                        audioSource.startsWith('https://') ||
                        audioSource.startsWith('file://');
      
      AppLogger.debug('Audio source type determined', tag: 'AudioPlayer', data: {'isUrl': isUrl});
      
      // Create the appropriate source type
      final Source source;
      if (isUrl) {
        source = UrlSource(audioSource);
        AppLogger.debug('Created UrlSource', tag: 'AudioPlayer');
      } else {
        // Local file path - use DeviceFileSource
        source = DeviceFileSource(audioSource);
        AppLogger.debug('Created DeviceFileSource', tag: 'AudioPlayer');
      }
      
      // Try to set the source
      // On macOS, sometimes we need to use play() then immediately stop
      // to properly load the audio
      try {
        AppLogger.debug('Attempting to set source', tag: 'AudioPlayer');
        await _audioPlayer.setSource(source);
        AppLogger.debug('Source set successfully', tag: 'AudioPlayer');
      } catch (setSourceError) {
        AppLogger.warning('setSource failed, trying alternative method', 
            tag: 'AudioPlayer', 
            data: setSourceError);
        // If setSource fails, try alternative method: play then immediately stop
        // This sometimes works better on macOS
        AppLogger.debug('Trying play() then stop() method', tag: 'AudioPlayer');
        await _audioPlayer.play(source);
        // Wait a tiny bit for it to start loading
        await Future.delayed(const Duration(milliseconds: 100));
        await _audioPlayer.stop();
        AppLogger.debug('Alternative method completed', tag: 'AudioPlayer');
      }
      
      // Wait for the player to initialize and get duration
      // Duration will be updated via the onDurationChanged stream subscription
      // Give it more time on macOS as it may need to download metadata
      AppLogger.debug('Waiting for player initialization', tag: 'AudioPlayer');
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // Verify the source was set correctly by checking if we can get state
      final playerState = _audioPlayer.state;
      AppLogger.debug('Player state checked', tag: 'AudioPlayer', data: {'state': playerState.toString()});
      
      if (playerState == PlayerState.disposed) {
        throw Exception('Audio player was disposed');
      }
      
      state = state.copyWith(
        status: PlaybackStatus.stopped,
        audioSource: audioSource,
      );
      
      AppLogger.info('Audio loaded successfully', tag: 'AudioPlayer', data: {
        'source': audioSource,
        'duration': state.duration,
      });
    } catch (e, stackTrace) {
      AppLogger.error('Failed to load audio', 
          tag: 'AudioPlayer',
          error: e,
          stackTrace: stackTrace);
      // Provide user-friendly error messages
      String errorMessage = 'Failed to load audio';
      final bool isUrl = audioSource.startsWith('http://') || 
                        audioSource.startsWith('https://') ||
                        audioSource.startsWith('file://');
      
      if (e.toString().contains('DarwinAudioError') || 
          e.toString().contains('AVPlayerItem.Status.failed')) {
        if (isUrl) {
          errorMessage = 'Unable to load audio from URL. This may be due to:\n'
              '• Network connectivity issues\n'
              '• Invalid or inaccessible audio URL\n'
              '• macOS security restrictions\n\n'
              'Please check the URL and try again.';
        } else {
          errorMessage = 'Unable to load local audio file. This may be due to:\n'
              '• File does not exist at the specified path\n'
              '• Insufficient file permissions\n'
              '• Unsupported audio format\n'
              '• macOS security restrictions\n\n'
              'Please check the file path and permissions.';
        }
      } else if (e.toString().contains('Network') || 
                 e.toString().contains('connection')) {
        errorMessage = 'Network error. Please check your internet connection.';
      } else if (e.toString().contains('File') || 
                 e.toString().contains('path') ||
                 e.toString().contains('permission')) {
        errorMessage = 'File access error. Please check:\n'
            '• File exists at the specified path\n'
            '• You have read permissions for the file\n'
            '• The file is a supported audio format';
      } else {
        errorMessage = 'Failed to load audio: ${e.toString()}';
      }
      
      state = state.copyWith(
        status: PlaybackStatus.error,
        errorMessage: errorMessage,
      );
    }
  }

  /// Start playing audio
  Future<void> play() async {
    AppLogger.info('Play requested', tag: 'AudioPlayer');
    
    if (state.audioSource == null || state.audioSource!.isEmpty) {
      AppLogger.warning('No audio source loaded', tag: 'AudioPlayer');
      state = state.copyWith(
        status: PlaybackStatus.error,
        errorMessage: 'No audio source loaded',
      );
      return;
    }

    try {
      final playerState = _audioPlayer.state;
      AppLogger.debug('Current player state', tag: 'AudioPlayer', data: {'state': playerState.toString(), 'appStatus': state.status.toString()});
      
      // If already paused, just resume without reloading
      if (playerState == PlayerState.paused && state.status == PlaybackStatus.paused) {
        AppLogger.debug('Resuming from paused state', tag: 'AudioPlayer');
        await _audioPlayer.resume();
        state = state.copyWith(
          status: PlaybackStatus.playing,
          errorMessage: null,
        );
        AppLogger.info('Audio resumed from pause', tag: 'AudioPlayer');
        return;
      }
      
      // Check if we need to load the audio source
      final currentSource = _audioPlayer.source;
      bool needsLoad = currentSource == null || 
                       playerState == PlayerState.stopped ||
                       playerState == PlayerState.disposed;
      
      // Also check if the source has changed by comparing the source string
      if (!needsLoad) {
        final currentSourceStr = currentSource.toString();
        final expectedSourceStr = state.audioSource!;
        // Check if source matches (handles both UrlSource and DeviceFileSource)
        final sourceMatches = currentSourceStr.contains(expectedSourceStr) ||
                             (currentSourceStr.contains('UrlSource') && expectedSourceStr.startsWith('http')) ||
                             (currentSourceStr.contains('DeviceFileSource') && !expectedSourceStr.startsWith('http'));
        needsLoad = !sourceMatches;
      }
      
      AppLogger.debug('Checking if audio needs to be loaded', 
          tag: 'AudioPlayer', 
          data: {'needsLoad': needsLoad, 'currentSource': currentSource?.toString(), 'playerState': playerState.toString()});
      
      if (needsLoad) {
        AppLogger.debug('Loading audio before playing', tag: 'AudioPlayer');
        await loadAudio(state.audioSource!);
      }
      
      // Resume or play depending on current state
      AppLogger.debug('Starting playback', tag: 'AudioPlayer', data: {'currentState': playerState.toString()});
      
      if (playerState == PlayerState.paused) {
        await _audioPlayer.resume();
      } else {
        await _audioPlayer.resume(); // resume() works for stopped state too
      }
      
      state = state.copyWith(
        status: PlaybackStatus.playing,
        errorMessage: null,
      );
      
      AppLogger.info('Audio playing', tag: 'AudioPlayer');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to play audio', 
          tag: 'AudioPlayer',
          error: e,
          stackTrace: stackTrace);
      state = state.copyWith(
        status: PlaybackStatus.error,
        errorMessage: 'Failed to play audio: ${e.toString()}',
      );
    }
  }

  /// Pause audio playback
  Future<void> pause() async {
    if (state.status != PlaybackStatus.playing) {
      return;
    }

    try {
      await _audioPlayer.pause();
      state = state.copyWith(
        status: PlaybackStatus.paused,
      );
    } catch (e) {
      state = state.copyWith(
        status: PlaybackStatus.error,
        errorMessage: 'Failed to pause audio: ${e.toString()}',
      );
    }
  }

  /// Stop audio playback and reset position
  Future<void> stop() async {
    try {
      await _audioPlayer.stop();
      state = state.copyWith(
        status: PlaybackStatus.stopped,
        position: 0,
      );
    } catch (e) {
      state = state.copyWith(
        status: PlaybackStatus.error,
        errorMessage: 'Failed to stop audio: ${e.toString()}',
      );
    }
  }

  /// Seek to a specific position in milliseconds
  Future<void> seek(int position) async {
    if (position < 0 || (state.duration > 0 && position > state.duration)) {
      return;
    }

    try {
      await _audioPlayer.seek(Duration(milliseconds: position));
      state = state.copyWith(position: position);
    } catch (e) {
      state = state.copyWith(
        status: PlaybackStatus.error,
        errorMessage: 'Failed to seek: ${e.toString()}',
      );
    }
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    if (volume < 0.0 || volume > 1.0) {
      return;
    }

    try {
      await _audioPlayer.setVolume(volume);
      state = state.copyWith(volume: volume);
    } catch (e) {
      // Volume setting failed, but don't update state
      // This is a non-critical error
    }
  }

  /// Set playback speed (0.5 to 2.0)
  Future<void> setPlaybackSpeed(double speed) async {
    if (speed < 0.5 || speed > 2.0) {
      return;
    }

    try {
      await _audioPlayer.setPlaybackRate(speed);
      state = state.copyWith(playbackSpeed: speed);
    } catch (e) {
      // Playback speed setting failed, but don't update state
      // This is a non-critical error
    }
  }

  /// Update current position (called by audio player callbacks)
  void updatePosition(int position) {
    state = state.copyWith(position: position);
  }

  /// Update duration (called when audio is loaded)
  void updateDuration(int duration) {
    state = state.copyWith(duration: duration);
  }

  /// Reset state to initial
  void reset() {
    state = AudioPlaybackState.initial();
  }
}

