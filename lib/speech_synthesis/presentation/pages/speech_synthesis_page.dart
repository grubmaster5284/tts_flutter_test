import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tts_flutter_test/speech_synthesis/application/providers/speech_synthesis_providers.dart';
import 'package:tts_flutter_test/speech_synthesis/presentation/controllers/speech_synthesis_ui_provider.dart';
import 'package:tts_flutter_test/speech_synthesis/presentation/widgets/language_selector_widget.dart';
import 'package:tts_flutter_test/speech_synthesis/presentation/widgets/loading_indicator_widget.dart';
import 'package:tts_flutter_test/speech_synthesis/presentation/widgets/service_selector_widget.dart';
import 'package:tts_flutter_test/speech_synthesis/presentation/widgets/text_input_field_widget.dart';
import 'package:tts_flutter_test/speech_synthesis/presentation/widgets/voice_selector_widget.dart';
import 'package:tts_flutter_test/core/utils/data_state.dart';
import 'package:tts_flutter_test/audio_playback/presentation/widgets/audio_player_widget.dart';

/// Main page for speech synthesis
class SpeechSynthesisPage extends ConsumerWidget {
  const SpeechSynthesisPage({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(speechSynthesisNotifierProvider);
    final textInput = ref.watch(textInputProvider);
    final selectedVoice = ref.watch(selectedVoiceProvider);
    final selectedLanguage = ref.watch(selectedLanguageProvider);
    final selectedAudioFormat = ref.watch(selectedAudioFormatProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Speech Synthesis'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Service selector
            const ServiceSelectorWidget(),
            const SizedBox(height: 16),
            
            // Text input
            const TextInputFieldWidget(),
            const SizedBox(height: 16),
            
            // Voice selector
            const VoiceSelectorWidget(),
            const SizedBox(height: 16),
            
            // Language selector
            const LanguageSelectorWidget(),
            const SizedBox(height: 16),
            
            // Audio format selector
            DropdownButtonFormField<String>(
              key: ValueKey('audio_format_$selectedAudioFormat'),
              initialValue: selectedAudioFormat,
              decoration: const InputDecoration(
                labelText: 'Audio Format',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: 'mp3', child: Text('MP3')),
                DropdownMenuItem(value: 'wav', child: Text('WAV')),
                DropdownMenuItem(value: 'ogg', child: Text('OGG')),
                DropdownMenuItem(value: 'aac', child: Text('AAC')),
                DropdownMenuItem(value: 'flac', child: Text('FLAC')),
              ],
              onChanged: (format) {
                if (format != null) {
                  ref.read(selectedAudioFormatProvider.notifier).state = format;
                }
              },
            ),
            const SizedBox(height: 24),
            
            // Synthesize button
            FilledButton.icon(
              onPressed: state.isLoading || textInput.trim().isEmpty
                  ? null
                  : () {
                      ref.read(speechSynthesisNotifierProvider.notifier).convertTextToSpeech(
                        text: textInput,
                        service: state.selectedService,
                        voice: selectedVoice,
                        language: selectedLanguage,
                        audioFormat: selectedAudioFormat,
                      );
                    },
              icon: const Icon(Icons.volume_up),
              label: Text('Synthesize Speech (${state.selectedService.name})'),
            ),
            const SizedBox(height: 24),
            
            // Loading indicator
            if (state.isLoading) const LoadingIndicatorWidget(),
            
            // Error display
            if (state.hasError)
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Theme.of(context).colorScheme.onErrorContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Error',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onErrorContainer,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _getErrorMessage(state.dataState.error),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            // Success display with audio player
            if (state.isSuccess && state.response != null) ...[
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Success',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Audio synthesized successfully!',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Format: ${state.response!.audioFormat.value}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      Text(
                        'Duration: ${state.response!.durationMs}ms',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Audio player for the synthesized audio
              AudioPlayerWidget(
                initialAudioSource: state.response!.audioData, // File path from repository
                showVolumeControl: true,
                showSpeedControl: true,
                compact: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  String _getErrorMessage(Object? error) {
    if (error == null) return 'Unknown error';
    return error.toString();
  }
}

