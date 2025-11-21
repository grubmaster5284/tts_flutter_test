import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper function to create a ProviderContainer for testing
/// 
/// This is useful for testing Riverpod providers in isolation
/// without needing a full widget tree.
ProviderContainer createTestContainer({
  List<Override>? overrides,
}) {
  return ProviderContainer(
    overrides: overrides ?? [],
  );
}

/// Helper function to create a ProviderScope widget for widget tests
/// 
/// This wraps a widget with ProviderScope and optional overrides
/// for testing widgets that depend on Riverpod providers.
Widget createTestWidget({
  required Widget child,
  List<Override>? overrides,
}) {
  return ProviderScope(
    overrides: overrides ?? [],
    child: child,
  );
}

/// Helper to wait for async operations in tests
/// 
/// Use this when testing async operations that need time to complete
Future<void> waitForAsync() async {
  await Future.delayed(const Duration(milliseconds: 100));
}

/// Helper to create mock data for tests
class TestDataFactory {
  static const String validLanguageCode = 'en';
  static const String validVoiceId = 'voice-123';
  static const String validText = 'Hello, world!';
  static const String validAudioFormat = 'mp3';
  
  static const String invalidLanguageCode = 'EN'; // uppercase
  static const String invalidVoiceId = 'voice@123'; // invalid character
  static const String emptyText = '';
  static const String invalidAudioFormat = 'invalid';
}

