import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_response_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/audio_format_vo.dart';

part 'speech_response_dto.freezed.dart';
part 'speech_response_dto.g.dart';

/// Data Transfer Object (DTO) for speech synthesis response
/// 
/// ## What is a DTO?
/// A Data Transfer Object (DTO) is a design pattern used to transfer data between different
/// layers of an application, particularly between the Domain layer and Data layer. Unlike domain
/// entities (models), DTOs are simple data containers without business logic or validation.
/// 
/// ## Why DTOs exist:
/// 1. **Serialization**: DTOs use primitive types (String, int, bool) instead of value objects,
///    making them easy to serialize to/from JSON for API communication
/// 2. **Layer Separation**: They provide a boundary between domain models (which contain business
///    logic) and data structures used for external communication
/// 3. **Framework Independence**: DTOs can be easily converted to JSON for HTTP requests, database
///    storage, or platform channel communication
/// 
/// ## Key Differences from Domain Models:
/// - **Domain Models** (SpeechResponseModel): Use value objects (AudioFormatVO) for type safety
///   and validation. They represent business concepts.
/// - **DTOs** (SpeechResponseDto): Use primitive types (String, int) for easy serialization.
///   They represent data structures for communication.
/// 
/// ## Freezed Package:
/// The `@freezed` annotation and `freezed_annotation` package generate:
/// - Immutable classes (all fields are final)
/// - `copyWith` method for creating modified copies
/// - `==` operator and `hashCode` for value equality
/// - `toString` method for debugging
/// 
/// ## JSON Serialization:
/// The `json_serializable` package (via `.g.dart` file) generates:
/// - `fromJson` factory constructor to deserialize JSON
/// - `toJson` method to serialize to JSON
/// 
/// This is part of the Data layer in clean architecture.
@Freezed(toJson: true, fromJson: true)
class SpeechResponseDto with _$SpeechResponseDto {
  /// Factory constructor for creating a SpeechResponseDto instance
  /// 
  /// All fields use primitive types (String, int) instead of value objects to enable
  /// easy JSON serialization for API communication.
  const factory SpeechResponseDto({
    /// Audio data as a String
    /// 
    /// **Content can be:**
    /// - Base64-encoded audio data (when received from API/script)
    /// - File path (after audio is saved to disk by the repository)
    /// 
    /// The repository saves base64 audio to a file and replaces this field with the file path
    /// for better performance (avoiding base64 encoding/decoding overhead).
    required String audioData,
    
    /// Audio format as a plain String (e.g., 'mp3', 'wav', 'ogg')
    /// 
    /// Unlike the domain model which uses AudioFormatVO (a value object), this is a simple
    /// String for easy serialization. The extension method `toDomain()` converts this to
    /// AudioFormatVO when creating the domain model.
    required String audioFormat,
    
    /// Duration of the audio in milliseconds
    /// 
    /// This represents how long the generated speech audio is. It's useful for:
    /// - Displaying progress during playback
    /// - Calculating playback position
    /// - UI feedback (showing audio length)
    required int durationMs,
    
    /// Optional metadata as a JSON string
    /// 
    /// This can contain additional information about the synthesis:
    /// - Service-specific metadata (voice used, model version, etc.)
    /// - Quality metrics
    /// - Processing time
    /// - Any other service-provided information
    /// 
    /// Stored as a JSON string to maintain flexibility across different services.
    String? metadata,
  }) = _SpeechResponseDto;
  
  /// Factory constructor to deserialize from JSON
  /// 
  /// This method wraps the generated fromJson to add custom error handling
  /// for missing required fields.
  /// 
  /// **Expected JSON structure:**
  /// ```json
  /// {
  ///   "audio_data": "base64_encoded_string_or_file_path",
  ///   "audio_format": "mp3",
  ///   "duration_ms": 5000,
  ///   "metadata": "{\"voice\": \"en-US-Standard-A\"}"
  /// }
  /// ```
  /// 
  /// Usage:
  /// ```dart
  /// final json = {'audio_data': '...', 'audio_format': 'mp3', 'duration_ms': 5000};
  /// final dto = SpeechResponseDto.fromJson(json);
  /// ```
  factory SpeechResponseDto.fromJson(Map<String, dynamic> json) {
    // Validate required fields before calling generated fromJson
    if (json['audio_data'] == null) {
      throw FormatException('Missing required field: audio_data');
    }
    if (json['audio_format'] == null) {
      throw FormatException('Missing required field: audio_format');
    }
    if (json['duration_ms'] == null) {
      throw FormatException('Missing required field: duration_ms');
    }
    
    // Convert snake_case keys to camelCase for generated fromJson
    final camelCaseJson = {
      'audioData': json['audio_data'],
      'audioFormat': json['audio_format'],
      'durationMs': json['duration_ms'],
      if (json['metadata'] != null) 'metadata': json['metadata'],
    };
    
    // Delegate to generated fromJson
    return _$SpeechResponseDtoFromJson(camelCaseJson);
  }
  
  /// Converts this DTO to a JSON map with snake_case field names
  /// 
  /// This method converts camelCase to snake_case for the backend API.
  @override
  Map<String, dynamic> toJson() {
    return {
      'audio_data': audioData,
      'audio_format': audioFormat,
      'duration_ms': durationMs,
      if (metadata != null) 'metadata': metadata,
    };
  }
}

/// Extension to convert DTO to domain model
/// 
/// ## What is an Extension?
/// Extensions in Dart allow adding methods to existing classes without modifying them.
/// This extension adds a `toDomain()` method to SpeechResponseDto to convert it to a
/// domain model.
/// 
/// ## Why Convert DTO to Domain Model?
/// The conversion process:
/// 1. **Reconstructs Value Objects**: Converts primitive types (String) back to value
///    objects (AudioFormatVO) for type safety and validation at the domain level
/// 2. **Layer Separation**: Keeps the domain layer independent of data layer structures
/// 3. **Type Safety**: Domain models use value objects that enforce business rules
/// 
/// ## Conversion Details:
/// - `audioData` (String) → `audioData` (String) - No conversion needed
/// - `audioFormat` (String) → `audioFormat` (AudioFormatVO) - Wraps String in value object
/// - `durationMs` (int) → `durationMs` (int) - No conversion needed
/// - `metadata` (String?) → `metadata` (String?) - No conversion needed
/// 
/// Usage:
/// ```dart
/// final dto = SpeechResponseDto(...);
/// final domainModel = dto.toDomain(); // Now has AudioFormatVO instead of String
/// ```
extension SpeechResponseDtoExtension on SpeechResponseDto {
  /// Converts this DTO to a domain model (SpeechResponseModel)
  /// 
  /// This method reconstructs value objects from primitive types, ensuring the domain
  /// layer receives properly typed, validated data structures.
  /// 
  /// **Returns:** A SpeechResponseModel instance with value objects instead of primitives
  SpeechResponseModel toDomain() {
    return SpeechResponseModel(
      // Pass audioData as-is (can be base64 or file path)
      audioData: audioData,
      
      // Convert String to AudioFormatVO value object
      // This ensures type safety and validation at the domain level
      audioFormat: AudioFormatVO(audioFormat),
      
      // Pass duration as-is (already a primitive int)
      durationMs: durationMs,
      
      // Pass metadata as-is (optional String)
      metadata: metadata,
    );
  }
}

