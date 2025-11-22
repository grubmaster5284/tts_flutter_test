import 'dart:typed_data';

/// Stub implementation for non-web platforms
/// This file is used when the platform is not web

String createBlobUrl(Uint8List bytes, String mimeType) {
  throw UnsupportedError('Blob URLs are only supported on web');
}

void revokeBlobUrl(String blobUrl) {
  // No-op on non-web platforms
}

