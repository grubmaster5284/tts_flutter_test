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
import 'package:tts_flutter_test/core/utils/logger.dart';

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
    final selectedService = service ?? state.selectedService;
    
    AppLogger.info('Starting text-to-speech conversion', tag: 'SpeechSynthesis', data: {
      'text': text.substring(0, text.length > 50 ? 50 : text.length) + (text.length > 50 ? '...' : ''),
      'service': selectedService.name,
      'voice': voice,
      'language': language,
      'audioFormat': audioFormat,
    });
    
    state = state.copyWith(
      dataState: const DataState.loading(),
      selectedService: selectedService,
    );
    
    try {
      // Create value objects
      AppLogger.debug('Creating value objects', tag: 'SpeechSynthesis');
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
        service: selectedService,
        voice: voiceVO,
        language: languageVO,
        audioFormat: audioFormatVO,
      );
      
      AppLogger.debug('Calling repository to convert text to speech', tag: 'SpeechSynthesis');
      
      // Call repository
      final result = await _repository.convertTextToSpeech(request);
      
      if (result.isSuccess) {
        final value = result.success;
        AppLogger.info('Text-to-speech conversion successful', tag: 'SpeechSynthesis', data: {
          'format': value.audioFormat.value,
          'duration': value.durationMs,
        });
        
        state = state.copyWith(
          dataState: DataState.success(value: value),
        );
      } else {
        final error = result.failure;
        AppLogger.error('Text-to-speech conversion failed', 
            tag: 'SpeechSynthesis',
            error: error);
        
        state = state.copyWith(
          dataState: DataState.failure(error),
        );
      }
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error during text-to-speech conversion',
          tag: 'SpeechSynthesis',
          error: e,
          stackTrace: stackTrace);
      
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

