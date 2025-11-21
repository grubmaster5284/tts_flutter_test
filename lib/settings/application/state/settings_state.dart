import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings_state.freezed.dart';

/// Immutable state class for app settings
/// 
/// This class represents the complete state of app settings at any given time.
/// It uses Freezed to generate immutable classes with copyWith methods, ensuring type safety
/// and preventing accidental state mutations.
/// 
/// The state includes:
/// - Default TTS service, voice, language, and audio format preferences
/// - Default volume and playback speed for audio playback
/// - Theme preference (light, dark, or system)
/// - Loading and saving states
/// - Error messages if operations fail
/// 
/// This is part of the Application layer in clean architecture and serves as the single
/// source of truth for settings state throughout the app.
@freezed
class SettingsState with _$SettingsState {
  const SettingsState._(); // Private constructor for extensions

  const factory SettingsState({
    /// Default TTS service (e.g., 'gemini', 'openai', 'polly')
    @Default('gemini') String defaultTtsService,
    
    /// Default voice identifier
    String? defaultVoice,
    
    /// Default language code (ISO 639-1 format)
    @Default('en') String defaultLanguage,
    
    /// Default audio format (e.g., 'mp3', 'wav', 'ogg')
    @Default('mp3') String defaultAudioFormat,
    
    /// Default playback volume (0.0 to 1.0)
    @Default(1.0) double defaultVolume,
    
    /// Default playback speed (0.5 to 2.0)
    @Default(1.0) double defaultPlaybackSpeed,
    
    /// Theme preference ('light', 'dark', 'system')
    @Default('system') String themePreference,
    
    /// Whether settings are currently being loaded
    @Default(false) bool isLoading,
    
    /// Whether settings are currently being saved
    @Default(false) bool isSaving,
    
    /// Error message if an error occurred
    String? errorMessage,
  }) = _SettingsState;

  /// Factory constructor for initial state
  factory SettingsState.initial() => const SettingsState();

  // Derived state helpers
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
  bool get isIdle => !isLoading && !isSaving;
}

