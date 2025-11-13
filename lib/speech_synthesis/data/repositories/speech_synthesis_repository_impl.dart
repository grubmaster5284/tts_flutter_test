import 'package:result_type/result_type.dart';
import 'package:tts_flutter_test/speech_synthesis/data/dtos/speech_request_dto.dart';
import 'package:tts_flutter_test/speech_synthesis/data/dtos/speech_response_dto.dart';
import 'package:tts_flutter_test/speech_synthesis/data/sources/local/speech_synthesis_local_service.dart';
import 'package:tts_flutter_test/speech_synthesis/data/sources/remote/speech_synthesis_remote_service.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_request_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_response_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/tts_service_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/repositories/i_speech_synthesis_repository.dart';

/// Repository implementation for speech synthesis
class SpeechSynthesisRepositoryImpl implements ISpeechSynthesisRepository {
  final SpeechSynthesisRemoteService _remoteService;
  final SpeechSynthesisLocalService _localService;
  
  SpeechSynthesisRepositoryImpl(
    this._remoteService,
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
      return Success(cachedResponse.toDomain());
    }
    
    // Convert domain model to DTO
    final requestDto = SpeechRequestDto.fromDomain(request);
    
    // Fetch from remote service
    final result = await _remoteService.synthesizeSpeech(requestDto);
    
    if (result.isSuccess) {
      final dto = result.success;
      _localService.saveResponse(cacheKey, dto);
      return Success(dto.toDomain());
    } else {
      return Failure(result.failure);
    }
  }
}

