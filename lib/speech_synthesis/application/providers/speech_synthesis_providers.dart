import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tts_flutter_test/speech_synthesis/application/state/speech_synthesis_notifier.dart';
import 'package:tts_flutter_test/speech_synthesis/application/state/speech_synthesis_state.dart';
import 'package:tts_flutter_test/speech_synthesis/data/repositories/speech_synthesis_repository_impl.dart';
import 'package:tts_flutter_test/speech_synthesis/data/sources/local/speech_synthesis_local_service.dart';
import 'package:tts_flutter_test/speech_synthesis/data/sources/local/speech_synthesis_script_service.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/repositories/i_speech_synthesis_repository.dart';

/// SharedPreferences provider
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// Script service provider (uses platform channels to execute Python scripts)
final speechSynthesisScriptServiceProvider = Provider<SpeechSynthesisScriptService>((ref) {
  return SpeechSynthesisScriptService();
});

/// Local service provider
final speechSynthesisLocalServiceProvider = Provider<SpeechSynthesisLocalService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider).value;
  if (prefs == null) {
    throw Exception('SharedPreferences not initialized');
  }
  return SpeechSynthesisLocalService(prefs);
});

/// Repository provider
final speechSynthesisRepositoryProvider = Provider<ISpeechSynthesisRepository>((ref) {
  final scriptService = ref.watch(speechSynthesisScriptServiceProvider);
  final localService = ref.watch(speechSynthesisLocalServiceProvider);
  return SpeechSynthesisRepositoryImpl(scriptService, localService);
});

/// Speech synthesis notifier provider
final speechSynthesisNotifierProvider =
    StateNotifierProvider<SpeechSynthesisNotifier, SpeechSynthesisState>((ref) {
  final repository = ref.watch(speechSynthesisRepositoryProvider);
  return SpeechSynthesisNotifier(repository);
});

