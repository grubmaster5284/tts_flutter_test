import 'package:flutter_riverpod/flutter_riverpod.dart';

/// UI-only state provider for selected voice
final selectedVoiceProvider = StateProvider<String?>((ref) => null);

/// UI-only state provider for selected language
final selectedLanguageProvider = StateProvider<String?>((ref) => null);

/// UI-only state provider for selected audio format
final selectedAudioFormatProvider = StateProvider<String>((ref) => 'mp3');

/// UI-only state provider for text input
final textInputProvider = StateProvider<String>((ref) => '');

/// UI-only state provider for speed (OpenAI only, default: 1.0)
/// Range: 0.25 to 4.0
final speedProvider = StateProvider<double>((ref) => 1.0);

/// UI-only state provider for instructions (OpenAI only, optional)
final instructionsProvider = StateProvider<String?>((ref) => null);

