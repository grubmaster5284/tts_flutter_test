import 'package:flutter/material.dart';

/// Widget for displaying and controlling audio playback progress
class AudioProgressBar extends StatelessWidget {
  /// Current progress (0.0 to 1.0)
  final double progress;

  /// Callback when user seeks to a new position
  /// Receives the new position in milliseconds
  final ValueChanged<int> onSeek;

  /// Whether the progress bar is enabled
  final bool enabled;

  /// Whether to show compact layout
  final bool compact;

  const AudioProgressBar({
    super.key,
    required this.progress,
    required this.onSeek,
    this.enabled = true,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: compact ? 2.0 : 4.0,
        thumbShape: compact
            ? const RoundSliderThumbShape(enabledThumbRadius: 6.0)
            : const RoundSliderThumbShape(enabledThumbRadius: 8.0),
        overlayShape: compact
            ? const RoundSliderOverlayShape(overlayRadius: 12.0)
            : const RoundSliderOverlayShape(overlayRadius: 16.0),
      ),
      child: Slider(
        value: progress.clamp(0.0, 1.0),
        onChanged: enabled
            ? (value) {
                // Convert progress (0.0-1.0) to position in milliseconds
                // We need duration to calculate position, but we'll use a callback
                // that the parent can handle with the actual duration
                onSeek((value * 1000).round());
              }
            : null,
        activeColor: Theme.of(context).colorScheme.primary,
        inactiveColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    );
  }
}

/// Extended progress bar that includes duration for accurate seeking
class AudioProgressBarWithDuration extends StatelessWidget {
  /// Current position in milliseconds
  final int position;

  /// Total duration in milliseconds
  final int duration;

  /// Callback when user seeks to a new position
  /// Receives the new position in milliseconds
  final ValueChanged<int> onSeek;

  /// Whether the progress bar is enabled
  final bool enabled;

  /// Whether to show compact layout
  final bool compact;

  const AudioProgressBarWithDuration({
    super.key,
    required this.position,
    required this.duration,
    required this.onSeek,
    this.enabled = true,
    this.compact = false,
  });

  double get progress {
    if (duration == 0) return 0.0;
    return (position / duration).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: compact ? 2.0 : 4.0,
        thumbShape: compact
            ? const RoundSliderThumbShape(enabledThumbRadius: 6.0)
            : const RoundSliderThumbShape(enabledThumbRadius: 8.0),
        overlayShape: compact
            ? const RoundSliderOverlayShape(overlayRadius: 12.0)
            : const RoundSliderOverlayShape(overlayRadius: 16.0),
      ),
      child: Slider(
        value: progress,
        onChanged: enabled && duration > 0
            ? (value) {
                final newPosition = (value * duration).round();
                onSeek(newPosition);
              }
            : null,
        activeColor: Theme.of(context).colorScheme.primary,
        inactiveColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    );
  }
}

