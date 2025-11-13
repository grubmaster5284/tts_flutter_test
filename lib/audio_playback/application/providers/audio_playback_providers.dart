import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tts_flutter_test/audio_playback/application/state/audio_playback_notifier.dart';
import 'package:tts_flutter_test/audio_playback/application/state/audio_playback_state.dart';

/// Provider for AudioPlaybackNotifier
/// 
/// This provider manages the audio playback state and provides
/// access to playback controls (play, pause, stop, seek, etc.)
final audioPlaybackNotifierProvider =
    StateNotifierProvider<AudioPlaybackNotifier, AudioPlaybackState>((ref) {
  return AudioPlaybackNotifier();
});

/// Convenience provider for accessing the notifier
final audioPlaybackNotifierRefProvider = Provider<AudioPlaybackNotifier>((ref) {
  return ref.read(audioPlaybackNotifierProvider.notifier);
});

/// Convenience provider for accessing the current state
final audioPlaybackStateProvider = Provider<AudioPlaybackState>((ref) {
  return ref.watch(audioPlaybackNotifierProvider);
});

