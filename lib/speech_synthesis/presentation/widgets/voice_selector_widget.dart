import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tts_flutter_test/speech_synthesis/presentation/controllers/speech_synthesis_ui_provider.dart';

/// Widget for selecting voice
class VoiceSelectorWidget extends ConsumerWidget {
  const VoiceSelectorWidget({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedVoice = ref.watch(selectedVoiceProvider);
    
    // Example voices - in a real app, these would come from the service
    final voices = ['alloy', 'echo', 'fable', 'onyx', 'nova', 'shimmer'];
    
    return DropdownButtonFormField<String>(
      initialValue: selectedVoice,
      decoration: const InputDecoration(
        labelText: 'Voice (Optional)',
        border: OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('Default'),
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

