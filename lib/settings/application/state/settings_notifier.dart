import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tts_flutter_test/settings/application/state/settings_state.dart';

/// Keys for SharedPreferences
class SettingsKeys {
  static const String defaultTtsService = 'default_tts_service';
  static const String defaultVoice = 'default_voice';
  static const String defaultLanguage = 'default_language';
  static const String defaultAudioFormat = 'default_audio_format';
  static const String defaultVolume = 'default_volume';
  static const String defaultPlaybackSpeed = 'default_playback_speed';
  static const String themePreference = 'theme_preference';
}

/// StateNotifier for managing settings state
class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier() : super(SettingsState.initial()) {
    _loadSettings();
  }

  /// Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final prefs = await SharedPreferences.getInstance();

      state = state.copyWith(
        defaultTtsService: prefs.getString(SettingsKeys.defaultTtsService) ?? 'gemini',
        defaultVoice: prefs.getString(SettingsKeys.defaultVoice),
        defaultLanguage: prefs.getString(SettingsKeys.defaultLanguage) ?? 'en',
        defaultAudioFormat: prefs.getString(SettingsKeys.defaultAudioFormat) ?? 'mp3',
        defaultVolume: prefs.getDouble(SettingsKeys.defaultVolume) ?? 1.0,
        defaultPlaybackSpeed: prefs.getDouble(SettingsKeys.defaultPlaybackSpeed) ?? 1.0,
        themePreference: prefs.getString(SettingsKeys.themePreference) ?? 'system',
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load settings: ${e.toString()}',
      );
    }
  }

  /// Save settings to SharedPreferences
  Future<void> saveSettings() async {
    state = state.copyWith(isSaving: true, errorMessage: null);

    try {
      final prefs = await SharedPreferences.getInstance();

      await Future.wait([
        prefs.setString(SettingsKeys.defaultTtsService, state.defaultTtsService),
        if (state.defaultVoice != null)
          prefs.setString(SettingsKeys.defaultVoice, state.defaultVoice!),
        prefs.setString(SettingsKeys.defaultLanguage, state.defaultLanguage),
        prefs.setString(SettingsKeys.defaultAudioFormat, state.defaultAudioFormat),
        prefs.setDouble(SettingsKeys.defaultVolume, state.defaultVolume),
        prefs.setDouble(SettingsKeys.defaultPlaybackSpeed, state.defaultPlaybackSpeed),
        prefs.setString(SettingsKeys.themePreference, state.themePreference),
      ]);

      state = state.copyWith(isSaving: false);
    } catch (e) {
      state = state.copyWith(
        isSaving: false,
        errorMessage: 'Failed to save settings: ${e.toString()}',
      );
    }
  }

  /// Update default TTS service
  Future<void> updateDefaultTtsService(String service) async {
    state = state.copyWith(defaultTtsService: service);
    await saveSettings();
  }

  /// Update default voice
  Future<void> updateDefaultVoice(String? voice) async {
    state = state.copyWith(defaultVoice: voice);
    await saveSettings();
  }

  /// Update default language
  Future<void> updateDefaultLanguage(String language) async {
    state = state.copyWith(defaultLanguage: language);
    await saveSettings();
  }

  /// Update default audio format
  Future<void> updateDefaultAudioFormat(String format) async {
    state = state.copyWith(defaultAudioFormat: format);
    await saveSettings();
  }

  /// Update default volume
  Future<void> updateDefaultVolume(double volume) async {
    if (volume < 0.0 || volume > 1.0) {
      return;
    }
    state = state.copyWith(defaultVolume: volume);
    await saveSettings();
  }

  /// Update default playback speed
  Future<void> updateDefaultPlaybackSpeed(double speed) async {
    if (speed < 0.5 || speed > 2.0) {
      return;
    }
    state = state.copyWith(defaultPlaybackSpeed: speed);
    await saveSettings();
  }

  /// Update theme preference
  Future<void> updateThemePreference(String theme) async {
    if (!['light', 'dark', 'system'].contains(theme)) {
      return;
    }
    state = state.copyWith(themePreference: theme);
    await saveSettings();
  }

  /// Reset all settings to defaults
  Future<void> resetToDefaults() async {
    state = SettingsState.initial();
    await saveSettings();
  }

  /// Reload settings from SharedPreferences
  Future<void> reload() async {
    await _loadSettings();
  }
}

