import 'package:flutter/material.dart';

/// Widget for displaying current position and total duration
class AudioTimeDisplay extends StatelessWidget {
  /// Formatted position string (e.g., "01:23")
  final String position;

  /// Formatted duration string (e.g., "03:45")
  final String duration;

  /// Whether to show compact layout
  final bool compact;

  const AudioTimeDisplay({
    super.key,
    required this.position,
    required this.duration,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = compact
        ? Theme.of(context).textTheme.bodySmall
        : Theme.of(context).textTheme.bodyMedium;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          position,
          style: textStyle?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          duration,
          style: textStyle?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

