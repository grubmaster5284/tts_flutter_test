import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tts_flutter_test/audio_playback/application/providers/audio_playback_providers.dart';
import 'package:tts_flutter_test/audio_playback/application/state/audio_playback_notifier.dart';
import 'package:tts_flutter_test/audio_playback/application/state/audio_playback_state.dart';
import 'package:tts_flutter_test/audio_playback/presentation/widgets/audio_controls.dart';
import 'package:tts_flutter_test/audio_playback/presentation/widgets/audio_progress_bar.dart';
import 'package:tts_flutter_test/audio_playback/presentation/widgets/audio_time_display.dart';
import 'package:tts_flutter_test/audio_playback/presentation/widgets/audio_volume_control.dart';
import 'package:tts_flutter_test/audio_playback/presentation/widgets/audio_speed_control.dart';

/// Main audio player widget that displays all playback controls and information
class AudioPlayerWidget extends ConsumerWidget {
  /// Optional audio source URL or path to load initially
  final String? initialAudioSource;

  /// Whether to show volume control
  final bool showVolumeControl;

  /// Whether to show playback speed control
  final bool showSpeedControl;

  /// Whether to show compact layout (for smaller spaces)
  final bool compact;

  const AudioPlayerWidget({
    super.key,
    this.initialAudioSource,
    this.showVolumeControl = true,
    this.showSpeedControl = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(audioPlaybackStateProvider);
    final notifier = ref.read(audioPlaybackNotifierRefProvider);

    // Load initial audio source if provided
    if (initialAudioSource != null &&
        state.audioSource != initialAudioSource) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifier.loadAudio(initialAudioSource!);
      });
    }

    if (compact) {
      return _buildCompactLayout(context, state, notifier);
    }

    return _buildFullLayout(context, state, notifier);
  }

  Widget _buildFullLayout(
    BuildContext context,
    AudioPlaybackState state,
    AudioPlaybackNotifier notifier,
  ) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Error message display
            if (state.hasError)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.errorContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.errorMessage ?? 'An error occurred',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onErrorContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Audio source display
            if (state.hasAudio)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Icon(
                      Icons.audiotrack,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        state.audioSource ?? '',
                        style: Theme.of(context).textTheme.bodyMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

            // Progress bar
            AudioProgressBarWithDuration(
              position: state.position,
              duration: state.duration,
              onSeek: (position) => notifier.seek(position),
              enabled: state.hasAudio && !state.isLoading,
            ),

            const SizedBox(height: 8),

            // Time display
            AudioTimeDisplay(
              position: state.formattedPosition,
              duration: state.formattedDuration,
            ),

            const SizedBox(height: 16),

            // Main controls (play/pause/stop)
            AudioControls(
              isPlaying: state.isPlaying,
              isPaused: state.isPaused,
              isLoading: state.isLoading,
              hasAudio: state.hasAudio,
              onPlay: () => notifier.play(),
              onPause: () => notifier.pause(),
              onStop: () => notifier.stop(),
            ),

            // Additional controls
            if (showVolumeControl || showSpeedControl) ...[
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  if (showVolumeControl)
                    Expanded(
                      child: AudioVolumeControl(
                        volume: state.volume,
                        onVolumeChanged: (volume) => notifier.setVolume(volume),
                      ),
                    ),
                  if (showVolumeControl && showSpeedControl)
                    const SizedBox(width: 16),
                  if (showSpeedControl)
                    Expanded(
                      child: AudioSpeedControl(
                        speed: state.playbackSpeed,
                        onSpeedChanged: (speed) =>
                            notifier.setPlaybackSpeed(speed),
                      ),
                    ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCompactLayout(
    BuildContext context,
    AudioPlaybackState state,
    AudioPlaybackNotifier notifier,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Play/Pause button
            AudioControls(
              isPlaying: state.isPlaying,
              isPaused: state.isPaused,
              isLoading: state.isLoading,
              hasAudio: state.hasAudio,
              onPlay: () => notifier.play(),
              onPause: () => notifier.pause(),
              onStop: () => notifier.stop(),
              compact: true,
            ),

            const SizedBox(width: 12),

            // Progress and time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  AudioProgressBarWithDuration(
                    position: state.position,
                    duration: state.duration,
                    onSeek: (position) => notifier.seek(position),
                    enabled: state.hasAudio && !state.isLoading,
                    compact: true,
                  ),
                  const SizedBox(height: 4),
                  AudioTimeDisplay(
                    position: state.formattedPosition,
                    duration: state.formattedDuration,
                    compact: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

