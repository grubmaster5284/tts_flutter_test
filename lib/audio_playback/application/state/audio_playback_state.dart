import 'package:freezed_annotation/freezed_annotation.dart';

part 'audio_playback_state.freezed.dart';

/// Represents the playback status of audio
enum PlaybackStatus {
  idle,
  loading,
  playing,
  paused,
  stopped,
  error,
}

/// Immutable state class for audio playback
@freezed
class AudioPlaybackState with _$AudioPlaybackState {
  const AudioPlaybackState._(); // Private constructor for extensions

  const factory AudioPlaybackState({
    /// Current playback status
    @Default(PlaybackStatus.idle) PlaybackStatus status,
    
    /// Current audio source URL or path
    String? audioSource,
    
    /// Current playback position in milliseconds
    @Default(0) int position,
    
    /// Total duration in milliseconds
    @Default(0) int duration,
    
    /// Volume level (0.0 to 1.0)
    @Default(1.0) double volume,
    
    /// Playback speed (1.0 = normal speed)
    @Default(1.0) double playbackSpeed,
    
    /// Error message if status is error
    String? errorMessage,
  }) = _AudioPlaybackState;

  /// Factory constructor for initial state
  factory AudioPlaybackState.initial() => const AudioPlaybackState();

  // Derived state helpers
  bool get isLoading => status == PlaybackStatus.loading;
  bool get isPlaying => status == PlaybackStatus.playing;
  bool get isPaused => status == PlaybackStatus.paused;
  bool get isStopped => status == PlaybackStatus.stopped;
  bool get hasError => status == PlaybackStatus.error;
  bool get hasAudio => audioSource != null && audioSource!.isNotEmpty;
  
  /// Progress percentage (0.0 to 1.0)
  double get progress {
    if (duration == 0) return 0.0;
    return position / duration;
  }
  
  /// Formatted position string (MM:SS)
  String get formattedPosition {
    final minutes = (position / 60000).floor();
    final seconds = ((position % 60000) / 1000).floor();
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
  
  /// Formatted duration string (MM:SS)
  String get formattedDuration {
    final minutes = (duration / 60000).floor();
    final seconds = ((duration % 60000) / 1000).floor();
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}

