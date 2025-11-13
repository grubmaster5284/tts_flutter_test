import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tts_flutter_test/speech_synthesis/application/providers/speech_synthesis_providers.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/tts_service_model.dart';

/// Widget for selecting TTS service
class ServiceSelectorWidget extends ConsumerWidget {
  const ServiceSelectorWidget({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(speechSynthesisNotifierProvider);
    
    return DropdownButtonFormField<TTSServiceModel>(
      initialValue: state.selectedService,
      decoration: const InputDecoration(
        labelText: 'TTS Service',
        border: OutlineInputBorder(),
      ),
      items: TTSServiceModel.values.map((service) {
        return DropdownMenuItem<TTSServiceModel>(
          value: service,
          child: Text(service.name),
        );
      }).toList(),
      onChanged: (service) {
        if (service != null) {
          ref.read(speechSynthesisNotifierProvider.notifier).setSelectedService(service);
        }
      },
    );
  }
}

