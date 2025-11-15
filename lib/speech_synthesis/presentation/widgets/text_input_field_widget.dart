import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tts_flutter_test/speech_synthesis/presentation/controllers/speech_synthesis_ui_provider.dart';

/// Widget for text input field
class TextInputFieldWidget extends ConsumerStatefulWidget {
  const TextInputFieldWidget({super.key});
  
  @override
  ConsumerState<TextInputFieldWidget> createState() => _TextInputFieldWidgetState();
}

class _TextInputFieldWidgetState extends ConsumerState<TextInputFieldWidget> {
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
    // Watch for external changes to text input
    final textInput = ref.watch(textInputProvider);
    
    // Update controller if text changed externally (but not from user typing)
    if (_controller.text != textInput && !_isUpdatingFromProvider) {
      _isUpdatingFromProvider = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _controller.text = textInput;
          _isUpdatingFromProvider = false;
        }
      });
    }
    
    return TextField(
      controller: _controller,
      maxLines: 5,
      decoration: const InputDecoration(
        labelText: 'Text to Synthesize',
        hintText: 'Enter text to convert to speech...',
        border: OutlineInputBorder(),
      ),
      onChanged: (value) {
        if (!_isUpdatingFromProvider) {
          ref.read(textInputProvider.notifier).state = value;
        }
      },
    );
  }
}

