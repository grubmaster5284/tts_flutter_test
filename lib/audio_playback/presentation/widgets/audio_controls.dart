import 'package:flutter/material.dart';

/// Widget for audio playback control buttons (play, pause, stop)
class AudioControls extends StatelessWidget {
  /// Whether audio is currently playing
  final bool isPlaying;

  /// Whether audio is currently paused
  final bool isPaused;

  /// Whether audio is currently loading
  final bool isLoading;

  /// Whether audio source is loaded
  final bool hasAudio;

  /// Callback when play button is pressed
  final VoidCallback onPlay;

  /// Callback when pause button is pressed
  final VoidCallback onPause;

  /// Callback when stop button is pressed
  final VoidCallback onStop;

  /// Whether to show compact layout
  final bool compact;

  const AudioControls({
    super.key,
    required this.isPlaying,
    required this.isPaused,
    required this.isLoading,
    required this.hasAudio,
    required this.onPlay,
    required this.onPause,
    required this.onStop,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    if (compact) {
      return _buildCompactControls(context);
    }

    return _buildFullControls(context);
  }

  Widget _buildFullControls(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Stop button
        IconButton(
          onPressed: hasAudio && !isLoading ? onStop : null,
          icon: const Icon(Icons.stop),
          iconSize: 32,
          tooltip: 'Stop',
        ),

        const SizedBox(width: 8),

        // Play/Pause button
        if (isLoading)
          const SizedBox(
            width: 64,
            height: 64,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
        else
          FilledButton.tonal(
            onPressed: hasAudio ? (isPlaying ? onPause : onPlay) : null,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.all(16),
              shape: const CircleBorder(),
              minimumSize: const Size(64, 64),
            ),
            child: Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              size: 32,
            ),
          ),
      ],
    );
  }

  Widget _buildCompactControls(BuildContext context) {
    return IconButton(
      onPressed: hasAudio && !isLoading
          ? (isPlaying ? onPause : onPlay)
          : null,
      icon: isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Icon(
              isPlaying ? Icons.pause : Icons.play_arrow,
              size: 28,
            ),
      tooltip: isPlaying ? 'Pause' : 'Play',
    );
  }
}

