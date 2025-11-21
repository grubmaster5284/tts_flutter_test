import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tts_flutter_test/speech_synthesis/application/state/speech_synthesis_notifier.dart';
import 'package:tts_flutter_test/speech_synthesis/application/state/speech_synthesis_state.dart';
import 'package:tts_flutter_test/speech_synthesis/data/repositories/speech_synthesis_repository_impl.dart';
import 'package:tts_flutter_test/speech_synthesis/data/sources/local/speech_synthesis_local_service.dart';
import 'package:tts_flutter_test/speech_synthesis/data/sources/local/speech_synthesis_script_service.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/repositories/i_speech_synthesis_repository.dart';

/// [FutureProvider] for SharedPreferences
/// 
/// This provider initializes and provides access to SharedPreferences, which is used
/// for persistent local storage (e.g., caching TTS responses, storing user preferences).
/// FutureProvider is used because SharedPreferences.getInstance() is an async operation.
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// [Provider] for SpeechSynthesisScriptService
/// 
/// This provider creates the script service that handles communication with Python scripts
/// via platform channels. The script service executes Python TTS scripts (Gemini, OpenAI)
/// and returns the audio data. This is part of the Data layer.
final speechSynthesisScriptServiceProvider = Provider<SpeechSynthesisScriptService>((ref) {
  return SpeechSynthesisScriptService();
});

/// [Provider] for SpeechSynthesisLocalService
/// 
/// This provider creates the local service that handles caching of TTS responses in
/// SharedPreferences. It checks for cached responses before making API calls and saves
/// successful responses for future use. This is part of the Data layer.
final speechSynthesisLocalServiceProvider = Provider<SpeechSynthesisLocalService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).value;
  if (prefs == null) {
    throw Exception('SharedPreferences not initialized');
  }
  return SpeechSynthesisLocalService(prefs);
});

/// [Provider] for ISpeechSynthesisRepository
/// 
/// This provider creates the repository implementation that coordinates between the
/// script service (for API calls) and local service (for caching). The repository
/// implements the domain interface, following the Repository pattern from clean architecture.
/// This bridges the Domain and Data layers.
final speechSynthesisRepositoryProvider = Provider<ISpeechSynthesisRepository>((ref) {
  final scriptService = ref.watch(speechSynthesisScriptServiceProvider);
  final localService = ref.watch(speechSynthesisLocalServiceProvider);
  return SpeechSynthesisRepositoryImpl(scriptService, localService);
});

/// [StateNotifierProvider] for SpeechSynthesisNotifier
/// 
/// This is the main provider that creates and manages the SpeechSynthesisNotifier.
/// It injects the repository dependency and provides reactive state management for
/// speech synthesis operations. This is part of the Application layer.
final speechSynthesisNotifierProvider =
    StateNotifierProvider<SpeechSynthesisNotifier, SpeechSynthesisState>((ref) {
  final repository = ref.watch(speechSynthesisRepositoryProvider);
  return SpeechSynthesisNotifier(repository);
});

