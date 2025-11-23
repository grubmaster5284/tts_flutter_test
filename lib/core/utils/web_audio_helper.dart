import 'dart:convert';
import 'package:flutter/foundation.dart' show kIsWeb;

// Conditional imports for web vs non-web platforms
import 'web_audio_helper_stub.dart'
    if (dart.library.html) 'web_audio_helper_web.dart';

// Top-level wrapper to avoid name shadowing in static method
void _revokeBlobUrlInternal(String blobUrl) => revokeBlobUrl(blobUrl);

/// Utility class for handling audio data on web platform
///
/// On web, browsers cannot access local file paths. Base64-encoded audio data
/// needs to be converted to a Blob URL for playback.
class WebAudioHelper {
  /// Converts base64-encoded audio data to a Blob URL on web
  ///
  /// **Process:**
  /// 1. Decodes base64 string to binary bytes
  /// 2. Creates a Blob from the bytes with appropriate MIME type
  /// 3. Creates a Blob URL using URL.createObjectURL()
  /// 4. Returns the blob URL that can be used with UrlSource
  ///
  /// **Parameters:**
  /// - `base64Data`: Base64-encoded audio data string
  /// - `audioFormat`: Audio format (mp3, wav, etc.) to determine MIME type
  ///
  /// **Returns:**
  /// - `String?`: Blob URL if on web, `null` if not on web
  ///
  /// **Note:**
  /// The caller is responsible for revoking the blob URL when done using
  /// `revokeBlobUrl()` to free up memory.
  static String? base64ToBlobUrl(String base64Data, String audioFormat) {
    if (!kIsWeb) {
      return null;
    }

    try {
      // Decode base64 to bytes
      final bytes = base64Decode(base64Data);

      // Determine MIME type from audio format
      final mimeType = _getMimeType(audioFormat);

      // Create blob URL using JavaScript interop
      return createBlobUrl(bytes, mimeType);
    } catch (e) {
      return null;
    }
  }

  /// Revokes a blob URL to free up memory
  ///
  /// **Parameters:**
  /// - `blobUrl`: The blob URL to revoke
  static void revokeBlobUrl(String blobUrl) {
    if (!kIsWeb) {
      return;
    }
    _revokeBlobUrlInternal(blobUrl);
  }

  /// Determines MIME type from audio format
  static String _getMimeType(String format) {
    switch (format.toLowerCase()) {
      case 'mp3':
        return 'audio/mpeg';
      case 'wav':
        return 'audio/wav';
      case 'ogg':
        return 'audio/ogg';
      case 'm4a':
        return 'audio/mp4';
      case 'aac':
        return 'audio/aac';
      case 'flac':
        return 'audio/flac';
      default:
        return 'audio/mpeg'; // Default to MP3
    }
  }
}
