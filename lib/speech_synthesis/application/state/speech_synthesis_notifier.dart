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

/// [StateNotifier] for managing speech synthesis state and operations
/// 
/// This class extends `StateNotifier<SpeechSynthesisState>` and serves as the business logic layer
/// for text-to-speech synthesis. It:
/// - Coordinates TTS requests by creating domain models (value objects, entities)
/// - Calls the repository to execute TTS conversion
/// - Manages state transitions (loading, success, error)
/// - Handles service selection and configuration
/// 
/// The StateNotifier pattern allows reactive state management where widgets automatically
/// rebuild when the state changes. This is part of the Application layer in clean architecture.
class SpeechSynthesisNotifier extends StateNotifier<SpeechSynthesisState> {
  final ISpeechSynthesisRepository _repository;
  
  SpeechSynthesisNotifier(this._repository) : super(SpeechSynthesisState.initial());
  
  /// Convert text to speech
  /// 
  /// This method handles service-specific formatting and validation before creating
  /// the domain model. It ensures that:
  /// - Voice is formatted correctly for each service
  /// - Language is formatted correctly for each service
  /// - Audio format is valid for each service
  /// - Service-specific parameters (speed, instructions) are properly set
  Future<void> convertTextToSpeech({
    required String text,
    TTSServiceModel? service,
    String? voice,
    String? language,
    String? audioFormat,
    double? speed,
    String? instructions,
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
      // Service-specific formatting and validation
      AppLogger.debug('Formatting parameters for service: ${selectedService.name}', tag: 'SpeechSynthesis');
      
      // Format voice based on service
      String? formattedVoice = voice;
      if (formattedVoice != null && formattedVoice.isNotEmpty) {
        // OpenAI: validate voice is in allowed list
        if (selectedService == TTSServiceModel.openai) {
          const validOpenAIVoices = ['alloy', 'echo', 'fable', 'onyx', 'nova', 'shimmer'];
          if (!validOpenAIVoices.contains(formattedVoice.toLowerCase())) {
            // Use default if invalid
            formattedVoice = 'alloy';
            AppLogger.warning('Invalid OpenAI voice, using default: alloy', tag: 'SpeechSynthesis');
          } else {
            formattedVoice = formattedVoice.toLowerCase();
          }
        }
        // Gemini: keep as-is (accepts voice names like "Kore")
        // Polly: (not yet implemented)
      } else {
        // Set service-specific defaults
        if (selectedService == TTSServiceModel.openai) {
          formattedVoice = 'alloy'; // OpenAI default
        } else if (selectedService == TTSServiceModel.gemini) {
          formattedVoice = 'Kore'; // Gemini default
        }
      }
      
      // Format language based on service
      String? formattedLanguage = language;
      if (formattedLanguage != null && formattedLanguage.isNotEmpty) {
        // OpenAI: language is optional, keep as-is if provided
        // Gemini: expects format like "en-US", validate/format if needed
        if (selectedService == TTSServiceModel.gemini) {
          // Ensure proper format (e.g., "en" -> "en-US", "en-US" stays "en-US")
          if (formattedLanguage.length == 2) {
            formattedLanguage = '$formattedLanguage-US'; // Default to US variant
          }
        }
      } else {
        // Set service-specific defaults
        if (selectedService == TTSServiceModel.gemini) {
          formattedLanguage = 'en-US'; // Gemini default
        }
        // OpenAI doesn't require language
      }
      
      // Format audio format based on service
      String formattedAudioFormat = audioFormat ?? 'mp3';
      
      // Validate audio format for service
      if (selectedService == TTSServiceModel.openai) {
        const validFormats = ['mp3', 'opus', 'aac', 'flac', 'wav', 'pcm'];
        if (!validFormats.contains(formattedAudioFormat.toLowerCase())) {
          formattedAudioFormat = 'mp3'; // Default
          AppLogger.warning('Invalid OpenAI audio format, using default: mp3', tag: 'SpeechSynthesis');
        }
      } else if (selectedService == TTSServiceModel.gemini) {
        const validFormats = ['mp3', 'wav', 'ogg', 'opus'];
        if (!validFormats.contains(formattedAudioFormat.toLowerCase())) {
          formattedAudioFormat = 'mp3'; // Default
          AppLogger.warning('Invalid Gemini audio format, using default: mp3', tag: 'SpeechSynthesis');
        }
      }
      
      // Format speed (OpenAI only, default: 1.0)
      double formattedSpeed = 1.0;
      if (selectedService == TTSServiceModel.openai && speed != null) {
        // Clamp speed to valid range (0.25 to 4.0)
        formattedSpeed = speed.clamp(0.25, 4.0);
      }
      
      // Format instructions (OpenAI only)
      String? formattedInstructions = instructions;
      if (selectedService != TTSServiceModel.openai) {
        formattedInstructions = null; // Only OpenAI supports instructions
      }
      
      // Create value objects with formatted values
      AppLogger.debug('Creating value objects', tag: 'SpeechSynthesis');
      final textVO = TextVO(text);
      final voiceVO = formattedVoice != null ? VoiceVO(formattedVoice) : null;
      final languageVO = formattedLanguage != null ? LanguageVO(formattedLanguage) : null;
      final audioFormatVO = AudioFormatVO(formattedAudioFormat);
      
      // Create request model
      final request = SpeechRequestModel.withDefaults(
        text: textVO,
        service: selectedService,
        voice: voiceVO,
        language: languageVO,
        audioFormat: audioFormatVO,
      );
      
      AppLogger.debug('Calling repository to convert text to speech', tag: 'SpeechSynthesis');
      
      // Call repository with service-specific parameters
      // Speed and instructions are passed separately since they're not in domain model
      final result = await _repository.convertTextToSpeech(
        request,
        speed: formattedSpeed,
        instructions: formattedInstructions,
      );
      
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

