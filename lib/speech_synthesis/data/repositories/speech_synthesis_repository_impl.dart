import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:result_type/result_type.dart';
import 'package:tts_flutter_test/speech_synthesis/data/dtos/speech_request_dto.dart';
import 'package:tts_flutter_test/speech_synthesis/data/dtos/speech_response_dto.dart';
import 'package:tts_flutter_test/speech_synthesis/data/sources/local/speech_synthesis_local_service.dart';
import 'package:tts_flutter_test/speech_synthesis/data/sources/local/speech_synthesis_script_service.dart';
import 'package:tts_flutter_test/speech_synthesis/data/sources/remote/speech_synthesis_remote_service.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_request_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_response_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/tts_service_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/repositories/i_speech_synthesis_repository.dart';
import 'package:tts_flutter_test/core/utils/logger.dart';

/// Repository implementation for speech synthesis
/// 
/// ## What is a Repository?
/// A Repository is a design pattern that abstracts data access logic from the domain layer.
/// It acts as a mediator between the domain layer (business logic) and data sources (APIs,
/// databases, local storage, etc.). The repository pattern provides:
/// 
/// 1. **Abstraction**: Domain layer doesn't need to know where data comes from (API, cache, etc.)
/// 2. **Single Source of Truth**: All data access goes through the repository
/// 3. **Testability**: Easy to mock repositories for unit testing
/// 4. **Flexibility**: Can change data sources without affecting domain logic
/// 
/// ## Repository Pattern in Clean Architecture:
/// - **Interface** (ISpeechSynthesisRepository): Defined in Domain layer - defines the contract
/// - **Implementation** (SpeechSynthesisRepositoryImpl): Defined in Data layer - implements the contract
/// 
/// ## This Repository Coordinates:
/// - **SpeechSynthesisScriptService**: Executes Python scripts via platform channels to call TTS APIs (desktop/mobile)
/// - **SpeechSynthesisRemoteService**: Makes HTTP requests to backend API for TTS synthesis (web)
/// - **SpeechSynthesisLocalService**: Handles local caching in SharedPreferences to avoid redundant API calls
/// 
/// ## Responsibilities:
/// 1. **Layer Conversion**: Converts between domain models (Domain layer) and DTOs (Data layer)
/// 2. **Caching Strategy**: Checks local cache before making API calls to improve performance
/// 3. **Data Persistence**: Saves successful responses to cache for future use
/// 4. **File Management**: Saves base64 audio data to disk files for efficient storage
/// 5. **Error Handling**: Converts data layer errors to domain errors
/// 
/// ## Data Flow:
/// ```
/// Domain Layer (SpeechRequestModel)
///     ↓
/// Repository (converts to DTO)
///     ↓
/// Check Cache → If found, return cached response
///     ↓ (if not cached)
/// Script Service (executes Python script)
///     ↓
/// Repository (saves to cache, converts to domain model)
///     ↓
/// Domain Layer (SpeechResponseModel)
/// ```
/// 
/// This is part of the Data layer in clean architecture.
class SpeechSynthesisRepositoryImpl implements ISpeechSynthesisRepository {
  /// Service for executing Python TTS scripts via platform channels
  /// 
  /// This service handles communication with native platform code (Android/iOS/macOS)
  /// to execute Python scripts that perform text-to-speech synthesis using various
  /// TTS providers (Google Gemini, OpenAI, AWS Polly).
  /// 
  /// **Platform Support**: Used on desktop and mobile platforms (not web)
  final SpeechSynthesisScriptService? _scriptService;
  
  /// Service for making HTTP requests to backend API
  /// 
  /// This service handles communication with a Python backend server over HTTP
  /// to perform text-to-speech synthesis. It's used on web platform where
  /// platform channels are not available.
  /// 
  /// **Platform Support**: Used on web platform
  final SpeechSynthesisRemoteService? _remoteService;
  
  /// Service for local caching of TTS responses
  /// 
  /// This service manages caching in SharedPreferences to avoid redundant API calls
  /// for the same text/voice/language combinations. It improves performance and
  /// reduces API costs.
  final SpeechSynthesisLocalService _localService;
  
  /// Constructor that initializes the repository with required services
  /// 
  /// **Dependency Injection**: Services are injected via constructor, making the
  /// repository testable (can inject mock services) and following SOLID principles.
  /// 
  /// **Platform Detection**: The repository automatically selects the appropriate
  /// service based on the platform (web uses remote service, others use script service).
  /// 
  /// **Parameters:**
  /// - `_scriptService`: Handles Python script execution via platform channels (desktop/mobile)
  /// - `_remoteService`: Handles HTTP requests to backend API (web)
  /// - `_localService`: Handles local caching in SharedPreferences
  SpeechSynthesisRepositoryImpl(
    this._scriptService,
    this._remoteService,
    this._localService,
  );
  
  /// Converts text to speech using the specified TTS service
  /// 
  /// This is the main method that implements the repository interface. It orchestrates
  /// the entire TTS synthesis process:
  /// 
  /// 1. **Cache Check**: First checks if a cached response exists for this request
  /// 2. **Domain to DTO Conversion**: Converts domain model to DTO for data layer operations
  /// 3. **Script Execution**: Calls the script service to execute Python TTS script
  /// 4. **File Storage**: Saves base64 audio data to disk for efficient storage
  /// 5. **Caching**: Saves successful response to cache for future use
  /// 6. **DTO to Domain Conversion**: Converts DTO back to domain model for domain layer
  /// 
  /// **Parameters:**
  /// - `request`: Domain model (SpeechRequestModel) containing text, service, voice, etc.
  /// 
  /// **Returns:**
  /// - `Result.success(SpeechResponseModel)`: On successful synthesis
  /// - `Result.failure(SpeechSynthesisError)`: On error (network, validation, service, etc.)
  /// 
  /// **Result Type Package:**
  /// The `result_type` package provides type-safe error handling without exceptions.
  /// Instead of throwing exceptions, methods return `Result<T, E>` which can be either:
  /// - `Success(T)`: Contains the successful result
  /// - `Failure(E)`: Contains the error
  /// 
  /// This approach makes error handling explicit and type-safe.
  @override
  Future<Result<SpeechResponseModel, SpeechSynthesisError>> convertTextToSpeech(
    SpeechRequestModel request,
  ) async {
    // Step 1: Generate cache key from request parameters
    // The cache key is a hash of text + service + voice + language + format
    // This ensures we can retrieve cached responses for identical requests
    final serviceValue = request.service.value;
    final cacheKey = SpeechSynthesisLocalService.generateCacheKey(
      text: request.text.value,
      service: serviceValue,
      voice: request.voice?.value,
      language: request.language?.value,
      audioFormat: request.audioFormat?.value ?? 'mp3',
    );
    
    // Step 2: Try local cache first (performance optimization)
    // If we have a cached response, return it immediately without making an API call
    final cachedResponse = _localService.getResponse(cacheKey);
    if (cachedResponse != null) {
      AppLogger.debug('Using cached TTS response', tag: 'TTSRepository');
      // Convert cached DTO to domain model and return success
      return Success(cachedResponse.toDomain());
    }
    
    // Step 3: Convert domain model to DTO
    // DTOs use primitive types (String, int) instead of value objects for serialization
    final requestDto = SpeechRequestDto.fromDomain(request);
    
    // Step 4: Execute TTS synthesis using platform-appropriate service
    // - Web: Uses remote service (HTTP requests to backend API)
    // - Desktop/Mobile: Uses script service (platform channels to Python scripts)
    final result = kIsWeb
        ? await _remoteService?.synthesizeSpeech(requestDto) ??
            Failure(SpeechSynthesisError.unknown('Remote service not available'))
        : await _scriptService?.synthesizeSpeech(requestDto) ??
            Failure(SpeechSynthesisError.unknown('Script service not available'));
    
    // Step 5: Process successful response
    if (result.isSuccess) {
      final dto = result.success;
      
      // Step 6: Save base64 audio data to disk file
      // This improves performance by avoiding base64 encoding/decoding overhead
      // The file path is stored in the DTO instead of base64 data
      final audioFilePath = await _saveAudioToFile(dto);
      if (audioFilePath != null) {
        // Create new DTO with file path instead of base64
        // This DTO will be cached and returned to the domain layer
        final updatedDto = SpeechResponseDto(
          audioData: audioFilePath, // Store file path instead of base64
          audioFormat: dto.audioFormat,
          durationMs: dto.durationMs,
          metadata: dto.metadata,
        );
        
        // Step 7: Cache the response for future use
        // Future requests with the same parameters will use this cached response
        _localService.saveResponse(cacheKey, updatedDto);
        
        // Step 8: Convert DTO to domain model and return success
        return Success(updatedDto.toDomain());
      } else {
        // If file save failed, still return the response but log warning
        // This is a graceful degradation - we can still use base64 data
        AppLogger.warning('Failed to save audio file, using base64 data', tag: 'TTSRepository');
        _localService.saveResponse(cacheKey, dto);
        return Success(dto.toDomain());
      }
    } else {
      // Step 9: Return failure if script execution failed
      // The error is already a domain error (SpeechSynthesisError) from the script service
      return Failure(result.failure);
    }
  }
  
  /// Saves base64-encoded audio data to a disk file and returns the file path
  /// 
  /// **Why save to file?**
  /// - **Performance**: Avoids base64 encoding/decoding overhead when reading audio
  /// - **Storage Efficiency**: Binary files are more efficient than base64 strings
  /// - **Memory**: Reduces memory usage by storing files instead of keeping data in memory
  /// 
  /// **Process:**
  /// 1. Gets the app's documents directory (platform-specific location for app data)
  /// 2. Creates a `tts_audio` subdirectory if it doesn't exist
  /// 3. Generates a unique filename using timestamp and audio format
  /// 4. Decodes base64 string to binary bytes
  /// 5. Writes bytes to file
  /// 6. Returns the file path (or null on failure)
  /// 
  /// **path_provider Package:**
  /// The `path_provider` package provides platform-specific paths:
  /// - **iOS**: `~/Library/Application Support/[app]/Documents/`
  /// - **Android**: `/data/data/[package]/app_flutter/`
  /// - **macOS**: `~/Library/Application Support/[app]/Documents/`
  /// 
  /// **dart:convert Package:**
  /// The `base64Decode` function converts a base64-encoded string to a `Uint8List`
  /// of bytes that can be written to a file.
  /// 
  /// **Parameters:**
  /// - `dto`: SpeechResponseDto containing base64-encoded audio data
  /// 
  /// **Returns:**
  /// - `String?`: File path if successful, `null` if failed
  /// 
  /// **Error Handling:**
  /// Returns `null` on any error (file system errors, permission issues, etc.)
  /// The calling method handles this gracefully by falling back to base64 data.
  Future<String?> _saveAudioToFile(SpeechResponseDto dto) async {
    try {
      AppLogger.debug('Saving audio to file', tag: 'TTSRepository', data: {
        'format': dto.audioFormat,
      });
      
      // On web, we can't use path_provider, so skip file saving
      if (kIsWeb) {
        AppLogger.debug('Skipping file save on web platform', tag: 'TTSRepository');
        return null;
      }
      
      // Get app documents directory using path_provider
      // This returns a platform-specific directory where the app can store files
      // The directory persists across app restarts
      final directory = await getApplicationDocumentsDirectory();
      
      // Create a subdirectory for TTS audio files
      // This keeps audio files organized and separate from other app data
      final audioDir = Directory('${directory.path}/tts_audio');
      if (!await audioDir.exists()) {
        // Create directory if it doesn't exist
        // `recursive: true` creates parent directories if needed
        await audioDir.create(recursive: true);
      }
      
      // Generate unique filename using timestamp and audio format
      // Timestamp ensures uniqueness even for multiple requests in quick succession
      // Format: `tts_1234567890.mp3`
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final filename = 'tts_$timestamp.${dto.audioFormat}';
      final filePath = '${audioDir.path}/$filename';
      
      // Decode base64 string to binary bytes
      // Base64 is a text encoding of binary data - we need to convert it back to bytes
      // to write it as a binary file
      final audioBytes = base64Decode(dto.audioData);
      
      // Write bytes to file
      // File.writeAsBytes() writes the binary data to disk atomically
      final file = File(filePath);
      await file.writeAsBytes(audioBytes);
      
      AppLogger.info('Audio saved to file', tag: 'TTSRepository', data: {
        'path': filePath,
        'size': audioBytes.length,
      });
      
      // Return the file path so it can be stored in the DTO and cached
      return filePath;
    } catch (e, stackTrace) {
      // Log error but don't throw - return null to allow graceful degradation
      // The calling method will fall back to using base64 data if file save fails
      AppLogger.error('Failed to save audio file',
          tag: 'TTSRepository',
          error: e,
          stackTrace: stackTrace);
      return null;
    }
  }
}

