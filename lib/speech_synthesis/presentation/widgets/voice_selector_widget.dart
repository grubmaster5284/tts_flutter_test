import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tts_flutter_test/speech_synthesis/presentation/controllers/speech_synthesis_ui_provider.dart';
import 'package:tts_flutter_test/speech_synthesis/application/providers/speech_synthesis_providers.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/tts_service_model.dart';

/// Widget for selecting voice
/// 
/// This widget is service-aware and shows different voices based on the selected service:
/// - OpenAI: alloy, echo, fable, onyx, nova, shimmer
/// - Gemini: Kore (default), and other Google Cloud voices
/// - Polly: (not yet implemented)
class VoiceSelectorWidget extends ConsumerWidget {
  const VoiceSelectorWidget({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedVoice = ref.watch(selectedVoiceProvider);
    final state = ref.watch(speechSynthesisNotifierProvider);
    final selectedService = state.selectedService;
    
    // Service-specific voices
    final List<String> voices;
    final String defaultVoice;
    final String helperText;
    
    switch (selectedService) {
      case TTSServiceModel.openai:
        voices = ['alloy', 'echo', 'fable', 'onyx', 'nova', 'shimmer'];
        defaultVoice = 'alloy';
        helperText = 'OpenAI voices';
        break;
      case TTSServiceModel.gemini:
        voices = ['Kore', 'Aoede', 'Charon', 'Fenrir', 'Puck'];
        defaultVoice = 'Kore';
        helperText = 'Gemini voices (Google Cloud TTS)';
        break;
      case TTSServiceModel.polly:
        voices = []; // Not yet implemented
        defaultVoice = '';
        helperText = 'Polly voices (not yet implemented)';
        break;
    }
    
    // Validate that selected voice is valid for current service
    // If not, reset to null (which will show default)
    String? validSelectedVoice = selectedVoice;
    if (selectedVoice != null && !voices.contains(selectedVoice)) {
      // Voice from previous service is not valid for current service
      // Reset to null to show default
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(selectedVoiceProvider.notifier).state = null;
      });
      validSelectedVoice = null;
    }
    
    // Use a key that includes the service to force rebuild when service changes
    // This ensures initialValue is properly set when switching services
    return DropdownButtonFormField<String>(
      key: ValueKey('voice_selector_${selectedService.name}_$validSelectedVoice'),
      initialValue: validSelectedVoice,
      decoration: InputDecoration(
        labelText: 'Voice (Optional)',
        border: const OutlineInputBorder(),
        helperText: helperText,
      ),
      items: [
        DropdownMenuItem<String>(
          value: null,
          child: Text('Default ($defaultVoice)'),
        ),
        ...voices.map((voice) {
          return DropdownMenuItem<String>(
            value: voice,
            child: Text(voice),
          );
        }),
      ],
      onChanged: (voice) {
        ref.read(selectedVoiceProvider.notifier).state = voice;
      },
    );
  }
}

