import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tts_flutter_test/speech_synthesis/application/state/speech_synthesis_notifier.dart';
import 'package:tts_flutter_test/speech_synthesis/application/state/speech_synthesis_state.dart';
import 'package:tts_flutter_test/speech_synthesis/data/repositories/speech_synthesis_repository_impl.dart';
import 'package:tts_flutter_test/speech_synthesis/data/sources/local/speech_synthesis_local_service.dart';
// [LEGACY] Old script service - commented out for rollback
// import 'package:tts_flutter_test/speech_synthesis/data/sources/local/speech_synthesis_script_service.dart';
// [LEGACY] Old remote service - commented out for rollback
// import 'package:tts_flutter_test/speech_synthesis/data/sources/remote/speech_synthesis_remote_service.dart';
// [NEW] New pure Dart TTS services
import 'package:tts_flutter_test/speech_synthesis/data/sources/remote/tts_service_factory.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/repositories/i_speech_synthesis_repository.dart';

/// [FutureProvider] for SharedPreferences
/// 
/// This provider initializes and provides access to SharedPreferences, which is used
/// for persistent local storage (e.g., caching TTS responses, storing user preferences).
/// FutureProvider is used because SharedPreferences.getInstance() is an async operation.
final sharedPreferencesProvider = FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

// [LEGACY] Old script service provider - commented out for rollback
// /// [Provider] for SpeechSynthesisScriptService
// /// 
// /// This provider creates the script service that handles communication with Python scripts
// /// via platform channels. The script service executes Python TTS scripts (Gemini, OpenAI)
// /// and returns the audio data. This is part of the Data layer.
// /// 
// /// **Platform Support**: Used on desktop and mobile platforms (not web)
// final speechSynthesisScriptServiceProvider = Provider<SpeechSynthesisScriptService?>((ref) {
//   return SpeechSynthesisScriptService();
// });

// [LEGACY] Old remote service provider - commented out for rollback
// /// [Provider] for SpeechSynthesisRemoteService
// /// 
// /// This provider creates the remote service that handles HTTP requests to the backend API.
// /// The remote service makes POST requests to a Python FastAPI backend that performs TTS synthesis.
// /// This is part of the Data layer.
// /// 
// /// **Platform Support**: Used on web platform
// final speechSynthesisRemoteServiceProvider = Provider<SpeechSynthesisRemoteService?>((ref) {
//   return SpeechSynthesisRemoteService(http.Client());
// });

// [NEW] TTS Service Factory provider - creates pure Dart TTS services
/// [Provider] for TtsServiceFactory
/// 
/// This provider creates the factory that creates appropriate pure Dart TTS service instances
/// (Gemini, OpenAI, Polly). The factory uses dependency injection to provide HTTP clients
/// to the services. This is part of the Data layer.
/// 
/// **Platform Support**: All platforms (web, desktop, mobile) use the same Dart services
final ttsServiceFactoryProvider = Provider<TtsServiceFactory>((ref) {
  return TtsServiceFactory(http.Client());
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
/// [NEW] This provider creates the repository implementation that coordinates between the
/// TTS service factory (for creating pure Dart TTS services) and local service (for caching).
/// The repository implements the domain interface, following the Repository pattern from
/// clean architecture. This bridges the Domain and Data layers.
/// 
/// **Platform Support**: All platforms (web, desktop, mobile) use the same pure Dart services
/// 
/// [LEGACY] Old implementation coordinated between script service (desktop/mobile) and
/// remote service (web). This has been replaced with a unified factory-based approach.
final speechSynthesisRepositoryProvider = Provider<ISpeechSynthesisRepository>((ref) {
  final serviceFactory = ref.watch(ttsServiceFactoryProvider);
  final localService = ref.watch(speechSynthesisLocalServiceProvider);
  return SpeechSynthesisRepositoryImpl(serviceFactory, localService);
  
  // [LEGACY] Old repository instantiation - commented out for rollback
  // final scriptService = ref.watch(speechSynthesisScriptServiceProvider);
  // final remoteService = ref.watch(speechSynthesisRemoteServiceProvider);
  // final localService = ref.watch(speechSynthesisLocalServiceProvider);
  // return SpeechSynthesisRepositoryImpl(scriptService, remoteService, localService);
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

