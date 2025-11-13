import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tts_flutter_test/audio_playback/presentation/widgets/audio_player_widget.dart';

void main() {
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

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

class AudioPlayerTestPage extends StatefulWidget {
  const AudioPlayerTestPage({super.key});

  @override
  State<AudioPlayerTestPage> createState() => _AudioPlayerTestPageState();
}

class _AudioPlayerTestPageState extends State<AudioPlayerTestPage> {
  final TextEditingController _audioUrlController = TextEditingController();
  String? _currentAudioSource;
  bool _compactMode = false;

  @override
  void dispose() {
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
                        decoration: InputDecoration(
                          labelText: 'Audio URL or File Path',
                          hintText: 'Enter audio URL or file path',
                          border: const OutlineInputBorder(),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _audioUrlController.clear();
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
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
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton.icon(
                            onPressed: () {
                              setState(() {
                                _currentAudioSource = null;
                                _audioUrlController.clear();
                              });
                            },
                            icon: const Icon(Icons.clear),
                            label: const Text('Clear'),
                          ),
                        ],
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
                          _buildExampleButton(
                            context,
                            'Sample WAV',
                            'https://www2.cs.uic.edu/~i101/SoundFiles/BabyElephantWalk60.wav',
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

  Widget _buildExampleButton(
    BuildContext context,
    String label,
    String url,
  ) {
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
}
