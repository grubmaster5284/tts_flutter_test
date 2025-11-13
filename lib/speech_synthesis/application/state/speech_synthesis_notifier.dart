import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_request_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/tts_service_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/repositories/i_speech_synthesis_repository.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/audio_format_vo.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/language_vo.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/text_vo.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/voice_vo.dart';
import 'package:tts_flutter_test/core/utils/data_state.dart';
import 'package:tts_flutter_test/speech_synthesis/application/state/speech_synthesis_state.dart';

/// StateNotifier for managing speech synthesis state
class SpeechSynthesisNotifier extends StateNotifier<SpeechSynthesisState> {
  final ISpeechSynthesisRepository _repository;
  
  SpeechSynthesisNotifier(this._repository) : super(SpeechSynthesisState.initial());
  
  /// Convert text to speech
  Future<void> convertTextToSpeech({
    required String text,
    TTSServiceModel? service,
    String? voice,
    String? language,
    String? audioFormat,
  }) async {
    state = state.copyWith(
      dataState: const DataState.loading(),
      selectedService: service ?? state.selectedService,
    );
    
    try {
      // Create value objects
      final textVO = TextVO(text);
      final voiceVO = voice != null ? VoiceVO(voice) : null;
      final languageVO = language != null ? LanguageVO(language) : null;
      AudioFormatVO? audioFormatVO;
      if (audioFormat != null) {
        audioFormatVO = AudioFormatVO(audioFormat);
      }
      
      // Create request model with default audio format if not provided
      final request = SpeechRequestModel.withDefaults(
        text: textVO,
        service: service ?? state.selectedService,
        voice: voiceVO,
        language: languageVO,
        audioFormat: audioFormatVO,
      );
      
      // Call repository
      final result = await _repository.convertTextToSpeech(request);
      
      if (result.isSuccess) {
        final value = result.success;
        state = state.copyWith(
          dataState: DataState.success(value: value),
        );
      } else {
        final error = result.failure;
        state = state.copyWith(
          dataState: DataState.failure(error),
        );
      }
    } catch (e) {
      state = state.copyWith(
        dataState: DataState.failure(e),
      );
    }
  }
  
  /// Set selected service
  void setSelectedService(TTSServiceModel service) {
    state = state.copyWith(selectedService: service);
  }
  
  /// Reset state to initial
  void reset() {
    state = SpeechSynthesisState.initial();
  }
}

