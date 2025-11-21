import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tts_flutter_test/speech_synthesis/data/dtos/speech_response_dto.dart';

/// Local service for caching speech synthesis responses
/// 
/// ## What is a Local Service?
/// A local service handles data operations that don't require external communication.
/// This service manages local caching of TTS responses to improve performance and
/// reduce API costs by avoiding redundant requests for the same text/voice combinations.
/// 
/// ## Caching Strategy:
/// - **Storage**: Uses SharedPreferences (key-value storage) to persist cache across app restarts
/// - **Expiry**: Cache entries expire after 24 hours to ensure freshness
/// - **Key Generation**: Cache keys are generated from request parameters (text, service, voice, etc.)
/// - **Automatic Cleanup**: Expired or invalid cache entries are automatically removed
/// 
/// ## SharedPreferences Package:
/// The `shared_preferences` package provides persistent key-value storage:
/// - **Platform Support**: Works on iOS, Android, macOS, Linux, Windows, Web
/// - **Persistence**: Data survives app restarts
/// - **Storage Location**:
///   - iOS: NSUserDefaults
///   - Android: SharedPreferences
///   - macOS: NSUserDefaults
/// - **Limitations**: Best for small data (strings, numbers, booleans). For large data,
///   consider using files or databases.
/// 
/// ## Cache Structure:
/// Each cache entry is stored as a JSON string containing:
/// ```json
/// {
///   "response": { /* SpeechResponseDto as JSON */ },
///   "cachedAt": "2024-01-01T12:00:00.000Z"
/// }
/// ```
/// 
/// This is part of the Data layer in clean architecture.
class SpeechSynthesisLocalService {
  /// Prefix for all cache keys in SharedPreferences
  /// 
  /// This prefix helps identify TTS cache entries and allows bulk operations
  /// (like clearing all cache) by filtering keys that start with this prefix.
  static const String _cachePrefix = 'tts_cache_';
  
  /// Default cache expiry duration (24 hours)
  /// 
  /// After this duration, cached responses are considered stale and will be
  /// removed. This ensures that cached data doesn't become too outdated.
  static const Duration _defaultCacheExpiry = Duration(hours: 24);
  
  /// SharedPreferences instance for persistent key-value storage
  /// 
  /// This is injected via constructor to allow for dependency injection and testing.
  /// SharedPreferences provides a simple way to store small amounts of data that
  /// persists across app restarts.
  final SharedPreferences _prefs;
  
  /// Constructor that initializes the service with SharedPreferences
  /// 
  /// **Dependency Injection**: SharedPreferences is injected via constructor,
  /// making the service testable (can inject mock SharedPreferences).
  /// 
  /// **Parameters:**
  /// - `_prefs`: SharedPreferences instance for storing/retrieving cache data
  SpeechSynthesisLocalService(this._prefs);
  
  /// Saves a speech synthesis response to the local cache
  /// 
  /// **Process:**
  /// 1. Converts the DTO to JSON using `toJson()` method
  /// 2. Wraps it with metadata (cachedAt timestamp)
  /// 3. Encodes the entire structure as a JSON string
  /// 4. Stores it in SharedPreferences with the cache key
  /// 
  /// **Parameters:**
  /// - `cacheKey`: Unique identifier for this cache entry (generated from request parameters)
  /// - `response`: SpeechResponseDto to cache
  /// 
  /// **Storage Format:**
  /// The response is stored as a JSON string containing:
  /// - `response`: The DTO serialized to JSON
  /// - `cachedAt`: ISO 8601 timestamp string for expiry checking
  /// 
  /// **dart:convert Package:**
  /// The `jsonEncode` function converts a Map to a JSON string for storage.
  Future<void> saveResponse(String cacheKey, SpeechResponseDto response) async {
    // Create cache entry with response and timestamp
    final cacheData = {
      'response': response.toJson(), // Convert DTO to JSON Map
      'cachedAt': DateTime.now().toIso8601String(), // ISO 8601 format: "2024-01-01T12:00:00.000Z"
    };
    
    // Store as JSON string in SharedPreferences
    // Key format: "tts_cache_<hash_code>"
    await _prefs.setString('$_cachePrefix$cacheKey', jsonEncode(cacheData));
  }
  
  /// Retrieves a cached speech synthesis response
  /// 
  /// **Process:**
  /// 1. Retrieves the cached JSON string from SharedPreferences
  /// 2. Decodes the JSON string to a Map
  /// 3. Checks if the cache entry has expired (older than 24 hours)
  /// 4. If expired, removes the entry and returns null
  /// 5. If valid, deserializes the response DTO from JSON
  /// 
  /// **Parameters:**
  /// - `cacheKey`: Unique identifier for the cache entry to retrieve
  /// 
  /// **Returns:**
  /// - `SpeechResponseDto?`: Cached response if found and valid, `null` otherwise
  /// 
  /// **Error Handling:**
  /// If the cache data is corrupted or invalid JSON, it's automatically removed
  /// and the method returns null. This prevents errors from propagating.
  SpeechResponseDto? getResponse(String cacheKey) {
    // Retrieve cached JSON string from SharedPreferences
    final cachedData = _prefs.getString('$_cachePrefix$cacheKey');
    if (cachedData == null) {
      // No cache entry found
      return null;
    }
    
    try {
      // Decode JSON string to Map
      final data = jsonDecode(cachedData) as Map<String, dynamic>;
      
      // Parse the cachedAt timestamp
      final cachedAt = DateTime.parse(data['cachedAt'] as String);
      
      // Check if cache is expired (older than 24 hours)
      if (DateTime.now().difference(cachedAt) > _defaultCacheExpiry) {
        // Remove expired cache entry
        _prefs.remove('$_cachePrefix$cacheKey');
        return null;
      }
      
      // Extract and deserialize the response DTO from JSON
      final responseData = data['response'] as Map<String, dynamic>;
      return SpeechResponseDto.fromJson(responseData);
    } catch (e) {
      // Invalid cache data (corrupted JSON, missing fields, etc.)
      // Remove the corrupted entry to prevent future errors
      _prefs.remove('$_cachePrefix$cacheKey');
      return null;
    }
  }
  
  /// Generates a cache key from request parameters
  /// 
  /// **Purpose:**
  /// Creates a unique identifier for a TTS request based on its parameters.
  /// Requests with identical parameters will generate the same cache key, allowing
  /// the cache to be reused.
  /// 
  /// **Key Generation Process:**
  /// 1. Combines all request parameters into a single string (separated by `|`)
  /// 2. Calculates the hash code of the combined string
  /// 3. Converts the hash code to a string
  /// 
  /// **Why Use Hash Code?**
  /// - **Uniqueness**: Different parameter combinations produce different hash codes
  /// - **Consistency**: Same parameters always produce the same hash code
  /// - **Length**: Hash codes are shorter than the full parameter string
  /// 
  /// **Parameters:**
  /// - `text`: The text to be synthesized (required)
  /// - `service`: TTS service identifier (required)
  /// - `voice`: Optional voice identifier
  /// - `language`: Optional language code
  /// - `audioFormat`: Optional audio format (defaults to 'mp3')
  /// 
  /// **Returns:**
  /// - `String`: Hash code string representing the unique cache key
  /// 
  /// **Example:**
  /// ```dart
  /// final key = generateCacheKey(
  ///   text: 'Hello',
  ///   service: 'gemini',
  ///   voice: 'en-US-Standard-A',
  ///   language: 'en',
  ///   audioFormat: 'mp3',
  /// );
  /// // Returns: "1234567890" (hash code as string)
  /// ```
  static String generateCacheKey({
    required String text,
    required String service,
    String? voice,
    String? language,
    String? audioFormat,
  }) {
    // Combine all parameters into a single string
    // Using '|' as separator to avoid conflicts with parameter values
    final keyParts = [
      text,
      service,
      voice ?? '', // Use empty string if null
      language ?? '', // Use empty string if null
      audioFormat ?? 'mp3', // Default to 'mp3' if null
    ];
    
    // Join parts with separator and calculate hash code
    // Hash code is an integer, so we convert it to string for use as a key
    return keyParts.join('|').hashCode.toString();
  }
  
  /// Clears all cached TTS responses
  /// 
  /// **Purpose:**
  /// Removes all cache entries that start with the cache prefix. This is useful for:
  /// - Freeing up storage space
  /// - Resetting cache after app updates
  /// - User-initiated cache clearing
  /// 
  /// **Process:**
  /// 1. Gets all keys from SharedPreferences
  /// 2. Filters keys that start with the cache prefix
  /// 3. Removes each matching key
  /// 
  /// **Usage:**
  /// Typically called from settings or when cache size becomes too large.
  Future<void> clearCache() async {
    // Get all keys from SharedPreferences
    final keys = _prefs.getKeys().where((key) => key.startsWith(_cachePrefix));
    
    // Remove each cache entry
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
}

