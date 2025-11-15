import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:result_type/result_type.dart';
import 'package:tts_flutter_test/speech_synthesis/data/dtos/speech_request_dto.dart';
import 'package:tts_flutter_test/speech_synthesis/data/dtos/speech_response_dto.dart';
import 'package:tts_flutter_test/speech_synthesis/data/sources/local/speech_synthesis_local_service.dart';
import 'package:tts_flutter_test/speech_synthesis/data/sources/local/speech_synthesis_script_service.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_request_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_response_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/tts_service_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/repositories/i_speech_synthesis_repository.dart';
import 'package:tts_flutter_test/core/utils/logger.dart';

/// Repository implementation for speech synthesis
class SpeechSynthesisRepositoryImpl implements ISpeechSynthesisRepository {
  final SpeechSynthesisScriptService _scriptService;
  final SpeechSynthesisLocalService _localService;
  
  SpeechSynthesisRepositoryImpl(
    this._scriptService,
    this._localService,
  );
  
  @override
  Future<Result<SpeechResponseModel, SpeechSynthesisError>> convertTextToSpeech(
    SpeechRequestModel request,
  ) async {
    // Generate cache key
    final serviceValue = request.service.value;
    final cacheKey = SpeechSynthesisLocalService.generateCacheKey(
      text: request.text.value,
      service: serviceValue,
      voice: request.voice?.value,
      language: request.language?.value,
      audioFormat: request.audioFormat?.value ?? 'mp3',
    );
    
    // Try local cache first
    final cachedResponse = _localService.getResponse(cacheKey);
    if (cachedResponse != null) {
      AppLogger.debug('Using cached TTS response', tag: 'TTSRepository');
      return Success(cachedResponse.toDomain());
    }
    
    // Convert domain model to DTO
    final requestDto = SpeechRequestDto.fromDomain(request);
    
    // Execute Python script via platform channel
    final result = await _scriptService.synthesizeSpeech(requestDto);
    
    if (result.isSuccess) {
      final dto = result.success;
      
      // Save audio to file and update DTO with file path
      final audioFilePath = await _saveAudioToFile(dto);
      if (audioFilePath != null) {
        // Create new DTO with file path instead of base64
        final updatedDto = SpeechResponseDto(
          audioData: audioFilePath, // Store file path instead of base64
          audioFormat: dto.audioFormat,
          durationMs: dto.durationMs,
          metadata: dto.metadata,
        );
        
        // Cache the response
        _localService.saveResponse(cacheKey, updatedDto);
        return Success(updatedDto.toDomain());
      } else {
        // If file save failed, still return the response but log warning
        AppLogger.warning('Failed to save audio file, using base64 data', tag: 'TTSRepository');
        _localService.saveResponse(cacheKey, dto);
        return Success(dto.toDomain());
      }
    } else {
      return Failure(result.failure);
    }
  }
  
  /// Save base64 audio data to a file and return the file path
  Future<String?> _saveAudioToFile(SpeechResponseDto dto) async {
    try {
      AppLogger.debug('Saving audio to file', tag: 'TTSRepository', data: {
        'format': dto.audioFormat,
      });
      
      // Get app documents directory
      final directory = await getApplicationDocumentsDirectory();
      final audioDir = Directory('${directory.path}/tts_audio');
      if (!await audioDir.exists()) {
        await audioDir.create(recursive: true);
      }
      
      // Generate filename
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = 'tts_$timestamp.${dto.audioFormat}';
      final filePath = '${audioDir.path}/$filename';
      
      // Decode base64 and write to file
      final audioBytes = base64Decode(dto.audioData);
      final file = File(filePath);
      await file.writeAsBytes(audioBytes);
      
      AppLogger.info('Audio saved to file', tag: 'TTSRepository', data: {
        'path': filePath,
        'size': audioBytes.length,
      });
      
      return filePath;
    } catch (e, stackTrace) {
      AppLogger.error('Failed to save audio file',
          tag: 'TTSRepository',
          error: e,
          stackTrace: stackTrace);
      return null;
    }
  }
}

