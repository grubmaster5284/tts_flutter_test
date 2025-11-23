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
import 'package:tts_flutter_test/speech_synthesis/domain/entities/tts_service_model.dart';

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
            
            // Audio format selector (service-aware)
            _buildAudioFormatSelector(ref, state.selectedService),
            const SizedBox(height: 16),
            
            // Service-specific fields
            if (state.selectedService == TTSServiceModel.openai) ...[
              _buildSpeedSelector(context, ref),
              const SizedBox(height: 16),
            ],
            
            // Instructions field (OpenAI and Gemini)
            if (state.selectedService == TTSServiceModel.openai || 
                state.selectedService == TTSServiceModel.gemini) ...[
              _buildInstructionsField(ref, state.selectedService),
              const SizedBox(height: 16),
            ],
            
            const SizedBox(height: 24),
            
            // Synthesize button
            FilledButton.icon(
              onPressed: state.isLoading || textInput.trim().isEmpty
                  ? null
                  : () {
                      // Get service-specific parameters
                      final speed = ref.read(speedProvider);
                      final instructions = ref.read(instructionsProvider);
                      
                      ref.read(speechSynthesisNotifierProvider.notifier).convertTextToSpeech(
                        text: textInput,
                        service: state.selectedService,
                        voice: selectedVoice,
                        language: selectedLanguage,
                        audioFormat: selectedAudioFormat,
                        speed: speed,
                        instructions: instructions,
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
  
  /// Builds audio format selector based on selected service
  Widget _buildAudioFormatSelector(WidgetRef ref, TTSServiceModel service) {
    final selectedAudioFormat = ref.watch(selectedAudioFormatProvider);
    
    // Service-specific audio formats
    final List<Map<String, String>> formats;
    
    switch (service) {
      case TTSServiceModel.openai:
        formats = [
          {'value': 'mp3', 'label': 'MP3'},
          {'value': 'opus', 'label': 'Opus'},
          {'value': 'aac', 'label': 'AAC'},
          {'value': 'flac', 'label': 'FLAC'},
          {'value': 'wav', 'label': 'WAV'},
          {'value': 'pcm', 'label': 'PCM'},
        ];
        break;
      case TTSServiceModel.gemini:
        formats = [
          {'value': 'mp3', 'label': 'MP3'},
          {'value': 'wav', 'label': 'WAV'},
          {'value': 'ogg', 'label': 'OGG'},
          {'value': 'opus', 'label': 'Opus'},
        ];
        break;
      case TTSServiceModel.polly:
        formats = [
          {'value': 'mp3', 'label': 'MP3'},
          {'value': 'wav', 'label': 'WAV'},
        ];
        break;
    }
    
    final currentValue = formats.any((f) => f['value'] == selectedAudioFormat) 
        ? selectedAudioFormat 
        : formats.first['value'];
    
    return DropdownButtonFormField<String>(
      key: ValueKey('audio_format_${service.name}_$selectedAudioFormat'),
      initialValue: currentValue,
      decoration: const InputDecoration(
        labelText: 'Audio Format',
        border: OutlineInputBorder(),
      ),
      items: formats.map((format) {
        return DropdownMenuItem<String>(
          value: format['value'],
          child: Text(format['label']!),
        );
      }).toList(),
      onChanged: (format) {
        if (format != null) {
          ref.read(selectedAudioFormatProvider.notifier).state = format;
        }
      },
    );
  }
  
  /// Builds speed selector for OpenAI (0.25 to 4.0)
  Widget _buildSpeedSelector(BuildContext context, WidgetRef ref) {
    final speed = ref.watch(speedProvider);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Speed: ${speed.toStringAsFixed(2)}x',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Slider(
          value: speed,
          min: 0.25,
          max: 4.0,
          divisions: 15, // 0.25 increments
          label: speed.toStringAsFixed(2),
          onChanged: (value) {
            ref.read(speedProvider.notifier).state = value;
          },
        ),
        Text(
          'Range: 0.25x to 4.0x (default: 1.0x)',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
  
  /// Builds instructions text field for OpenAI and Gemini
  Widget _buildInstructionsField(WidgetRef ref, TTSServiceModel service) {
    return _InstructionsTextField(
      key: ValueKey('instructions_field_${service.name}'),
      service: service,
    );
  }
}

/// Stateful widget for instructions text field to properly manage controller
class _InstructionsTextField extends ConsumerStatefulWidget {
  final TTSServiceModel service;
  
  const _InstructionsTextField({
    super.key,
    required this.service,
  });
  
  @override
  ConsumerState<_InstructionsTextField> createState() => _InstructionsTextFieldState();
}

class _InstructionsTextFieldState extends ConsumerState<_InstructionsTextField> {
  late TextEditingController _controller;
  bool _isUpdatingFromProvider = false;
  
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }
  
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    final instructions = ref.watch(instructionsProvider);
    final instructionsText = instructions ?? '';
    
    // Update controller if text changed externally (but not from user typing)
    if (_controller.text != instructionsText && !_isUpdatingFromProvider) {
      _isUpdatingFromProvider = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.text = instructionsText;
          _controller.selection = TextSelection.fromPosition(
            TextPosition(offset: instructionsText.length),
          );
          _isUpdatingFromProvider = false;
        }
      });
    }
    
    // Service-specific helper text
    final String helperText;
    final String hintText;
    
    switch (widget.service) {
      case TTSServiceModel.openai:
        helperText = 'OpenAI-specific: Produces subtle tone/style adjustments. For stronger emotional expression, try different voices or adjust speed. Note: Instructions have limited effectiveness for dramatic emotions.';
        hintText = 'e.g., "Speak professionally" or "Pause after each sentence"';
        break;
      case TTSServiceModel.gemini:
        helperText = 'Gemini-specific: Provides guidance on tone and speaking style. Example: "Say the following in an elated way"';
        hintText = 'e.g., "Say the following in an elated way" or "Speak with enthusiasm"';
        break;
      case TTSServiceModel.polly:
        helperText = 'Instructions not yet supported for Polly';
        hintText = 'Not available';
        break;
    }
    
    return TextField(
      controller: _controller,
      maxLines: 3,
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      decoration: InputDecoration(
        labelText: 'Instructions (Optional)',
        hintText: hintText,
        border: const OutlineInputBorder(),
        helperText: helperText,
      ),
      onChanged: (value) {
        if (!_isUpdatingFromProvider) {
          ref.read(instructionsProvider.notifier).state = 
              value.isEmpty ? null : value;
        }
      },
    );
  }
}

