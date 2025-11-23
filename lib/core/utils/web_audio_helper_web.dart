import 'dart:js_interop';
import 'dart:typed_data';
import 'package:web/web.dart' as web;

/// Web implementation for creating blob URLs
/// This file is used when the platform is web

String createBlobUrl(Uint8List bytes, String mimeType) {
  // Convert Uint8List to JSArray<BlobPart>
  // BlobPart can be a JSAny, so we convert the bytes to a JSArray
  final jsBytes = bytes.toJS;
  final blobParts = <web.BlobPart>[jsBytes].toJS;
  
  // Create a Blob from the bytes
  final blobOptions = web.BlobPropertyBag(type: mimeType);
  final blob = web.Blob(blobParts, blobOptions);
  
  // Create a blob URL (returns String directly, not JSString)
  final blobUrl = web.URL.createObjectURL(blob);
  
  return blobUrl;
}

void revokeBlobUrl(String blobUrl) {
  // Revoke the blob URL to free up memory
  // revokeObjectURL expects a String, not JSString
  web.URL.revokeObjectURL(blobUrl);
}

