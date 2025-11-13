import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tts_flutter_test/settings/application/state/settings_notifier.dart';
import 'package:tts_flutter_test/settings/application/state/settings_state.dart';

/// Provider for SettingsNotifier
/// 
/// This provider manages the app settings state and provides
/// access to settings management (load, save, update, etc.)
final settingsNotifierProvider =
    StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  return SettingsNotifier();
});

/// Convenience provider for accessing the notifier
final settingsNotifierRefProvider = Provider<SettingsNotifier>((ref) {
  return ref.read(settingsNotifierProvider.notifier);
});

/// Convenience provider for accessing the current state
final settingsStateProvider = Provider<SettingsState>((ref) {
  return ref.watch(settingsNotifierProvider);
});

