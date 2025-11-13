import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tts_flutter_test/speech_synthesis/data/dtos/speech_response_dto.dart';

/// Local service for caching speech synthesis responses
class SpeechSynthesisLocalService {
  static const String _cachePrefix = 'tts_cache_';
  static const Duration _defaultCacheExpiry = Duration(hours: 24);
  
  final SharedPreferences _prefs;
  
  SpeechSynthesisLocalService(this._prefs);
  
  /// Save a speech response to cache
  Future<void> saveResponse(String cacheKey, SpeechResponseDto response) async {
    final cacheData = {
      'response': response.toJson(),
      'cachedAt': DateTime.now().toIso8601String(),
    };
    await _prefs.setString('$_cachePrefix$cacheKey', jsonEncode(cacheData));
  }
  
  /// Get a cached speech response
  SpeechResponseDto? getResponse(String cacheKey) {
    final cachedData = _prefs.getString('$_cachePrefix$cacheKey');
    if (cachedData == null) {
      return null;
    }
    
    try {
      final data = jsonDecode(cachedData) as Map<String, dynamic>;
      final cachedAt = DateTime.parse(data['cachedAt'] as String);
      
      // Check if cache is expired
      if (DateTime.now().difference(cachedAt) > _defaultCacheExpiry) {
        _prefs.remove('$_cachePrefix$cacheKey');
        return null;
      }
      
      final responseData = data['response'] as Map<String, dynamic>;
      return SpeechResponseDto.fromJson(responseData);
    } catch (e) {
      // Invalid cache data, remove it
      _prefs.remove('$_cachePrefix$cacheKey');
      return null;
    }
  }
  
  /// Generate cache key from request parameters
  static String generateCacheKey({
    required String text,
    required String service,
    String? voice,
    String? language,
    String? audioFormat,
  }) {
    final keyParts = [
      text,
      service,
      voice ?? '',
      language ?? '',
      audioFormat ?? 'mp3',
    ];
    return keyParts.join('|').hashCode.toString();
  }
  
  /// Clear all cached responses
  Future<void> clearCache() async {
    final keys = _prefs.getKeys().where((key) => key.startsWith(_cachePrefix));
    for (final key in keys) {
      await _prefs.remove(key);
    }
  }
}

