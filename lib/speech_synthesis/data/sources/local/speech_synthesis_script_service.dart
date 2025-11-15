import 'package:flutter/services.dart';
import 'package:result_type/result_type.dart';
import 'package:tts_flutter_test/speech_synthesis/data/dtos/speech_request_dto.dart';
import 'package:tts_flutter_test/speech_synthesis/data/dtos/speech_response_dto.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';
import 'package:tts_flutter_test/core/utils/logger.dart';

/// Service for executing Python TTS scripts via platform channels
class SpeechSynthesisScriptService {
  static const MethodChannel _channel = MethodChannel('com.tts_flutter_test/tts_script');
  
  /// Synthesize speech by executing Python script
  Future<Result<SpeechResponseDto, SpeechSynthesisError>> synthesizeSpeech(
    SpeechRequestDto request,
  ) async {
    AppLogger.info('Executing TTS Python script', tag: 'TTSScriptService', data: {
      'service': request.service,
      'textLength': request.text.length,
      'voice': request.voice,
      'language': request.language,
      'audioFormat': request.audioFormat,
    });
    
    try {
      final arguments = <String, dynamic>{
        'service': request.service,
        'text': request.text,
        'voice': request.voice,
        'language': request.language,
        'audio_format': request.audioFormat,
      };
      
      // Add optional parameters
      if (request.service == 'gemini') {
        // Gemini-specific params can be added here if needed
      } else if (request.service == 'openai') {
        // OpenAI-specific params can be added here if needed
      }
      
      final result = await _channel.invokeMethod<Map<Object?, Object?>>(
        'synthesizeSpeech',
        arguments,
      );
      
      if (result == null) {
        AppLogger.error('Script returned null result', tag: 'TTSScriptService');
        return Failure(SpeechSynthesisError.unknown('Script execution returned no result'));
      }
      
      // Check for error in result
      if (result.containsKey('error')) {
        final errorMsg = result['error'] as String? ?? 'Unknown error from script';
        AppLogger.error('Script returned error', tag: 'TTSScriptService', error: errorMsg);
        return Failure(SpeechSynthesisError.unknown(errorMsg));
      }
      
      // Convert result to DTO
      final responseDto = SpeechResponseDto(
        audioData: result['audio_data'] as String? ?? '',
        audioFormat: result['audio_format'] as String? ?? 'mp3',
        durationMs: result['duration_ms'] as int? ?? 0,
        metadata: result['metadata'] as String?,
      );
      
      AppLogger.info('TTS script execution successful', tag: 'TTSScriptService');
      
      return Success(responseDto);
    } on PlatformException catch (e) {
      AppLogger.error('Platform exception during script execution', 
          tag: 'TTSScriptService',
          error: e);
      
      // Map platform errors to domain errors
      if (e.code == 'SCRIPT_NOT_FOUND') {
        return Failure(SpeechSynthesisError.unknown(
          'Python script not found. Please ensure scripts are in the app bundle.'
        ));
      } else if (e.code == 'SANDBOX_ERROR') {
        return Failure(SpeechSynthesisError.unknown(
          e.message ?? 'App Sandbox is blocking Python execution. Please install Xcode Command Line Tools.'
        ));
      } else if (e.code == 'PYTHON_NOT_FOUND') {
        return Failure(SpeechSynthesisError.unknown(
          e.message ?? 'Python 3 not found. Please install Xcode Command Line Tools: xcode-select --install'
        ));
      } else if (e.code == 'TTS_ERROR') {
        return Failure(SpeechSynthesisError.serviceError(e.message ?? 'TTS service error'));
      } else if (e.code == 'INVALID_ARGUMENTS') {
        return Failure(SpeechSynthesisError.validation(e.message ?? 'Invalid arguments'));
      }
      
      return Failure(SpeechSynthesisError.unknown(e.message ?? 'Platform error: ${e.code}'));
    } catch (e, stackTrace) {
      AppLogger.error('Unexpected error during script execution',
          tag: 'TTSScriptService',
          error: e,
          stackTrace: stackTrace);
      return Failure(SpeechSynthesisError.unknown(e.toString()));
    }
  }
}

