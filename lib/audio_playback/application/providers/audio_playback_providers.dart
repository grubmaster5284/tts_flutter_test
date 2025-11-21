import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tts_flutter_test/audio_playback/application/state/audio_playback_notifier.dart';
import 'package:tts_flutter_test/audio_playback/application/state/audio_playback_state.dart';

/// [StateNotifierProvider] for AudioPlaybackNotifier
/// 
/// This is the main provider that creates and manages the lifecycle of the AudioPlaybackNotifier.
/// StateNotifierProvider is a Riverpod provider type that manages stateful logic through a StateNotifier.
/// It automatically handles state updates and notifies all listening widgets when the state changes.
/// 
/// Usage: `ref.watch(audioPlaybackNotifierProvider)` to get the current state,
/// or `ref.read(audioPlaybackNotifierProvider.notifier)` to access the notifier methods.
final audioPlaybackNotifierProvider =
    StateNotifierProvider<AudioPlaybackNotifier, AudioPlaybackState>((ref) {
  return AudioPlaybackNotifier();
});

/// Convenience [Provider] for accessing the AudioPlaybackNotifier instance
/// 
/// This provider gives direct access to the notifier (the StateNotifier instance) without
/// needing to use `.notifier` syntax. Useful when you need to call methods like play(), pause(), etc.
/// 
/// Note: Uses `ref.read()` instead of `ref.watch()` because we only need the notifier reference,
/// not reactive updates to it.
final audioPlaybackNotifierRefProvider = Provider<AudioPlaybackNotifier>((ref) {
  return ref.read(audioPlaybackNotifierProvider.notifier);
});

/// Convenience [Provider] for accessing the current AudioPlaybackState
/// 
/// This provider gives direct access to the current state value without needing to use
/// the full provider path. Uses `ref.watch()` to automatically rebuild widgets when state changes.
/// 
/// This is the recommended way to access state in widgets that need to react to state changes.
final audioPlaybackStateProvider = Provider<AudioPlaybackState>((ref) {
  return ref.watch(audioPlaybackNotifierProvider);
});

