import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tts_flutter_test/speech_synthesis/presentation/controllers/speech_synthesis_ui_provider.dart';

/// Widget for text input field
class TextInputFieldWidget extends ConsumerWidget {
  const TextInputFieldWidget({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return TextField(
      maxLines: 5,
      decoration: const InputDecoration(
        labelText: 'Text to Synthesize',
        hintText: 'Enter text to convert to speech...',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        ref.read(textInputProvider.notifier).state = value;
      },
    );
  }
}

