import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tts_flutter_test/settings/application/state/settings_notifier.dart';
import 'package:tts_flutter_test/settings/application/state/settings_state.dart';

/// [StateNotifierProvider] for SettingsNotifier
/// 
/// This is the main provider that creates and manages the lifecycle of the SettingsNotifier.
/// StateNotifierProvider is a Riverpod provider type that manages stateful logic through a StateNotifier.
/// It automatically handles state updates and notifies all listening widgets when the state changes.
/// 
/// The SettingsNotifier manages app-wide settings like:
/// - Default TTS service preferences
/// - Default voice, language, and audio format
/// - Default volume and playback speed
/// - Theme preferences
/// 
/// Usage: `ref.watch(settingsNotifierProvider)` to get the current state,
/// or `ref.read(settingsNotifierProvider.notifier)` to access the notifier methods.
final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

/// Convenience [Provider] for accessing the SettingsNotifier instance
/// 
/// This provider gives direct access to the notifier (the StateNotifier instance) without
/// needing to use `.notifier` syntax. Useful when you need to call methods like updateDefaultTtsService(), etc.
/// 
/// Note: Uses `ref.read()` instead of `ref.watch()` because we only need the notifier reference,
/// not reactive updates to it.
final settingsNotifierRefProvider = Provider<SettingsNotifier>((ref) {
  return ref.read(settingsNotifierProvider.notifier);
});

/// Convenience [Provider] for accessing the current SettingsState
/// 
/// This provider gives direct access to the current state value without needing to use
/// the full provider path. Uses `ref.watch()` to automatically rebuild widgets when state changes.
/// 
/// This is the recommended way to access settings state in widgets that need to react to changes.
final settingsStateProvider = Provider<SettingsState>((ref) {
  return ref.watch(settingsNotifierProvider);
});

