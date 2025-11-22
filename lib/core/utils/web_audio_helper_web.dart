import 'dart:html' as html;
import 'dart:typed_data';

/// Web implementation for creating blob URLs
/// This file is used when the platform is web

String createBlobUrl(Uint8List bytes, String mimeType) {
  // Create a Blob from the bytes
  final blob = html.Blob([bytes], mimeType);
  
  // Create a blob URL
  final blobUrl = html.Url.createObjectUrlFromBlob(blob);
  
  return blobUrl;
}

void revokeBlobUrl(String blobUrl) {
  // Revoke the blob URL to free up memory
  html.Url.revokeObjectUrl(blobUrl);
}

