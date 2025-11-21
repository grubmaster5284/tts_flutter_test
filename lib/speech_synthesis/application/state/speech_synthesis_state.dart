import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_response_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/tts_service_model.dart';
import 'package:tts_flutter_test/core/utils/data_state.dart';

part 'speech_synthesis_state.freezed.dart';

/// Immutable state class for speech synthesis
/// 
/// This class represents the complete state of the speech synthesis system at any given time.
/// It uses Freezed to generate immutable classes with copyWith methods, ensuring type safety
/// and preventing accidental state mutations.
/// 
/// The state includes:
/// - dataState: The async state of TTS operations (initial, loading, success, failure)
/// - selectedService: The currently selected TTS service (Gemini, OpenAI, etc.)
/// - isRefreshing: Whether a refresh operation is in progress
/// 
/// This is part of the Application layer in clean architecture and serves as the single
/// source of truth for speech synthesis state throughout the app.
@freezed
class SpeechSynthesisState with _$SpeechSynthesisState {
  const SpeechSynthesisState._(); // Private constructor for extensions
  
  const factory SpeechSynthesisState({
    @Default(DataState<SpeechResponseModel>.initial())
        DataState<SpeechResponseModel> dataState,
    @Default(TTSServiceModel.gemini) TTSServiceModel selectedService,
    @Default(false) bool isRefreshing,
  }) = _SpeechSynthesisState;
  
  // Derived state helpers
  bool get isLoading => dataState.isLoading;
  bool get hasError => dataState.hasFailure;
  bool get isSuccess => dataState.isSuccess;
  SpeechResponseModel? get response => dataState.value;
  
  factory SpeechSynthesisState.initial() => const SpeechSynthesisState();
}

