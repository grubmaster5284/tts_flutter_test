import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:media_key_detector/media_key_detector.dart';
import 'package:tts_flutter_test/audio_playback/application/providers/audio_playback_providers.dart';
import 'package:tts_flutter_test/audio_playback/presentation/widgets/audio_player_widget.dart';
import 'package:tts_flutter_test/core/utils/logger.dart';
import 'package:tts_flutter_test/core/utils/media_key_handler.dart';
import 'package:tts_flutter_test/speech_synthesis/presentation/pages/speech_synthesis_page.dart';

// Conditional import for web blob URL creation
import 'package:tts_flutter_test/core/utils/web_audio_helper_stub.dart'
    if (dart.library.html) 'package:tts_flutter_test/core/utils/web_audio_helper_web.dart'
    as web_helper;

/// Main entry point of the application
///
/// This function initializes the Flutter app with a ProviderScope, which is required
/// for Riverpod state management. ProviderScope provides the dependency injection
/// container that manages all providers throughout the app lifecycle.
///
/// It also loads environment variables from .env file for configuration.
Future<void> main() async {
  AppLogger.info('App starting', tag: 'App');

  // Load environment variables from .env file (if it exists)
  try {
    await dotenv.load(fileName: '.env');
    AppLogger.info('Environment variables loaded from .env file', tag: 'App');
  } catch (e) {
    // .env file is optional - app can still work with other credential methods
    AppLogger.debug(
      'No .env file found or error loading it (this is OK)',
      tag: 'App',
      data: e,
    );
  }

  runApp(const ProviderScope(child: MyApp()));
}

/// Root widget of the application
///
/// This StatelessWidget sets up the MaterialApp with theme configuration.
/// It defines the app's title, theme, and initial route (AudioPlayerTestPage).
/// This is the top-level widget that wraps all other widgets in the app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Audio Playback Test',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AudioPlayerTestPage(),
    );
  }
}

/// Main page widget for audio player testing
///
/// This is a ConsumerStatefulWidget, which means it can access Riverpod providers
/// using the `ref` parameter. ConsumerStatefulWidget is part of the Riverpod package
/// and allows widgets to reactively rebuild when provider state changes.
///
/// This page demonstrates the audio playback functionality with:
/// - Audio file loading (from URL or local file system)
/// - Full audio player controls
/// - Media key support on desktop platforms
/// - Navigation to speech synthesis page
class AudioPlayerTestPage extends ConsumerStatefulWidget {
  const AudioPlayerTestPage({super.key});

  @override
  ConsumerState<AudioPlayerTestPage> createState() =>
      _AudioPlayerTestPageState();
}

/// State class for AudioPlayerTestPage
///
/// This state class manages the UI state for the audio player test page, including:
/// - Text controller for audio URL input
/// - Current audio source tracking
/// - Compact mode toggle
/// - Media key initialization (on desktop platforms)
class _AudioPlayerTestPageState extends ConsumerState<AudioPlayerTestPage> {
  final TextEditingController _audioUrlController = TextEditingController();
  String? _currentAudioSource;
  bool _compactMode = false;

  @override
  void initState() {
    super.initState();
    // Initialize media key handler after the first frame (only on desktop platforms)
    if (_isDesktopPlatform()) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _initializeMediaKeys();
      });
    }
  }

  /// Check if running on a desktop platform that supports media keys
  bool _isDesktopPlatform() {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  void _initializeMediaKeys() {
    final audioNotifier = ref.read(audioPlaybackNotifierRefProvider);

    MediaKeyHandler.instance.initialize(
      onMediaKeyPressed: (MediaKey key) {
        AppLogger.info(
          'Media key pressed',
          tag: 'MediaKeys',
          data: {'key': key.toString()},
        );

        final currentState = ref.read(audioPlaybackStateProvider);

        // Handle media key based on available enum values
        // The package provides: playPause, rewind, and fastForward
        switch (key) {
          case MediaKey.playPause:
            // Toggle play/pause
            if (currentState.isPlaying) {
              audioNotifier.pause();
            } else if (currentState.isPaused || currentState.isStopped) {
              audioNotifier.play();
            }
            break;
          case MediaKey.fastForward:
            // Fast forward 10 seconds
            final currentPosition = currentState.position;
            final newPosition = currentPosition + 10000;
            final maxPosition = currentState.duration > 0
                ? currentState.duration
                : newPosition;
            audioNotifier.seek(newPosition.clamp(0, maxPosition));
            break;
          case MediaKey.rewind:
            // Rewind 10 seconds
            final currentPosition = currentState.position;
            audioNotifier.seek(
              (currentPosition - 10000).clamp(0, double.infinity).toInt(),
            );
            break;
        }
      },
      onVolumeKeyPressed: (bool isVolumeUp) {
        AppLogger.info(
          'Volume key pressed',
          tag: 'MediaKeys',
          data: {'isVolumeUp': isVolumeUp},
        );

        final currentVolume = ref.read(audioPlaybackStateProvider).volume;
        final volumeStep = 0.05; // 5% per press
        final newVolume = isVolumeUp
            ? (currentVolume + volumeStep).clamp(0.0, 1.0)
            : (currentVolume - volumeStep).clamp(0.0, 1.0);

        audioNotifier.setVolume(newVolume);
      },
    );
  }

  @override
  void dispose() {
    if (_isDesktopPlatform()) {
      MediaKeyHandler.instance.dispose();
    }
    _audioUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Player Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.record_voice_over),
            tooltip: 'Speech Synthesis',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SpeechSynthesisPage(),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(_compactMode ? Icons.expand : Icons.compress),
            tooltip: 'Toggle compact mode',
            onPressed: () {
              setState(() {
                _compactMode = !_compactMode;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Audio URL input section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Load Audio',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _audioUrlController,
                        textDirection: TextDirection.ltr,
                        decoration: InputDecoration(
                          labelText: 'Audio URL or File Path',
                          hintText: 'Enter audio URL or select a file',
                          border: const OutlineInputBorder(),
                          suffixIcon: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.folder),
                                tooltip: 'Browse for audio file',
                                onPressed: _pickAudioFile,
                              ),
                              IconButton(
                                icon: const Icon(Icons.clear),
                                tooltip: 'Clear',
                                onPressed: () {
                                  _audioUrlController.clear();
                                  setState(() {
                                    _currentAudioSource = null;
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () {
                          final url = _audioUrlController.text.trim();
                          if (url.isNotEmpty) {
                            setState(() {
                              _currentAudioSource = url;
                            });
                          }
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Load Audio'),
                      ),
                      const SizedBox(height: 8),
                      // Example URLs
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildExampleButton(
                            context,
                            'Sample MP3',
                            'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Audio Player Widget
            AudioPlayerWidget(
              initialAudioSource: _currentAudioSource,
              showVolumeControl: true,
              showSpeedControl: true,
              compact: _compactMode,
            ),

            // Additional test player (compact mode)
            if (!_compactMode) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Compact Player Example',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              const SizedBox(height: 8),
              AudioPlayerWidget(
                initialAudioSource: _currentAudioSource,
                showVolumeControl: false,
                showSpeedControl: false,
                compact: true,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildExampleButton(BuildContext context, String label, String url) {
    return OutlinedButton(
      onPressed: () {
        _audioUrlController.text = url;
        setState(() {
          _currentAudioSource = url;
        });
      },
      style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      child: Text(label),
    );
  }

  /// Pick an audio file from the file system
  Future<void> _pickAudioFile() async {
    AppLogger.info('Opening file picker', tag: 'FilePicker');

    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: [
          'mp3',
          'wav',
          'm4a',
          'aac',
          'ogg',
          'flac',
          'wma',
          'mp4',
          'm4v',
          'mov',
        ],
        dialogTitle: 'Select an audio file',
        lockParentWindow: true,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.single;
        String audioSource;

        if (kIsWeb) {
          // On web, use bytes to create a blob URL
          final bytes = file.bytes;
          if (bytes == null) {
            AppLogger.warning('File bytes are null on web', tag: 'FilePicker');
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Unable to read file. Please try again.'),
                  backgroundColor: Theme.of(context).colorScheme.error,
                ),
              );
            }
            return;
          }

          // Get file extension to determine MIME type
          final extension = file.extension ?? 'mp3';
          final mimeType = _getMimeTypeFromExtension(extension);

          // Create blob URL from bytes
          audioSource = web_helper.createBlobUrl(bytes, mimeType);
          AppLogger.info(
            'File selected (web)',
            tag: 'FilePicker',
            data: {
              'name': file.name,
              'extension': extension,
              'size': file.size,
            },
          );
        } else {
          // On non-web platforms, use file path
          final filePath = file.path;
          if (filePath == null) {
            AppLogger.debug(
              'File picker cancelled or no path available',
              tag: 'FilePicker',
            );
            return;
          }

          audioSource = filePath;
          AppLogger.info(
            'File selected',
            tag: 'FilePicker',
            data: {'path': filePath},
          );
        }

        setState(() {
          _audioUrlController.text = file.name;
          _currentAudioSource = audioSource;
        });
      } else {
        AppLogger.debug('File picker cancelled', tag: 'FilePicker');
      }
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error picking file',
        tag: 'FilePicker',
        error: e,
        stackTrace: stackTrace,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking file: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  /// Get MIME type from file extension
  String _getMimeTypeFromExtension(String extension) {
    switch (extension.toLowerCase()) {
      case 'mp3':
        return 'audio/mpeg';
      case 'wav':
        return 'audio/wav';
      case 'm4a':
        return 'audio/mp4';
      case 'aac':
        return 'audio/aac';
      case 'ogg':
        return 'audio/ogg';
      case 'flac':
        return 'audio/flac';
      case 'wma':
        return 'audio/x-ms-wma';
      case 'mp4':
        return 'video/mp4';
      case 'm4v':
        return 'video/x-m4v';
      case 'mov':
        return 'video/quicktime';
      default:
        return 'audio/mpeg'; // Default to MP3
    }
  }
}
