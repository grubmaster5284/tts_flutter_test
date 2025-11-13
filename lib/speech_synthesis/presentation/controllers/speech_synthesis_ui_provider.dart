import 'package:flutter_riverpod/flutter_riverpod.dart';

/// UI-only state provider for selected voice
final selectedVoiceProvider = StateProvider<String?>((ref) => null);

/// UI-only state provider for selected language
final selectedLanguageProvider = StateProvider<String?>((ref) => null);

/// UI-only state provider for selected audio format
final selectedAudioFormatProvider = StateProvider<String>((ref) => 'mp3');

/// UI-only state provider for text input
final textInputProvider = StateProvider<String>((ref) => '');

