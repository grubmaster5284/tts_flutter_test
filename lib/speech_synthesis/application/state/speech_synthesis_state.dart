import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_response_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/tts_service_model.dart';
import 'package:tts_flutter_test/core/utils/data_state.dart';

part 'speech_synthesis_state.freezed.dart';

/// Immutable state class for speech synthesis
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

