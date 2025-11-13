import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tts_flutter_test/speech_synthesis/application/state/speech_synthesis_notifier.dart';
import 'package:tts_flutter_test/speech_synthesis/application/state/speech_synthesis_state.dart';
import 'package:tts_flutter_test/speech_synthesis/data/repositories/speech_synthesis_repository_impl.dart';
import 'package:tts_flutter_test/speech_synthesis/data/sources/local/speech_synthesis_local_service.dart';
import 'package:tts_flutter_test/speech_synthesis/data/sources/remote/speech_synthesis_remote_service.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/repositories/i_speech_synthesis_repository.dart';

/// HTTP client provider
final httpClientProvider = Provider<http.Client>((ref) => http.Client());

/// SharedPreferences provider
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

/// Remote service provider
final speechSynthesisRemoteServiceProvider = Provider<SpeechSynthesisRemoteService>((ref) {
  final client = ref.watch(httpClientProvider);
  return SpeechSynthesisRemoteService(client);
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
  final remoteService = ref.watch(speechSynthesisRemoteServiceProvider);
  final localService = ref.watch(speechSynthesisLocalServiceProvider);
  return SpeechSynthesisRepositoryImpl(remoteService, localService);
});

/// Speech synthesis notifier provider
final speechSynthesisNotifierProvider =
    StateNotifierProvider<SpeechSynthesisNotifier, SpeechSynthesisState>((ref) {
  final repository = ref.watch(speechSynthesisRepositoryProvider);
  return SpeechSynthesisNotifier(repository);
});

