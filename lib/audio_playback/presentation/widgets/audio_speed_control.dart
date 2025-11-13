import 'package:flutter/material.dart';

/// Widget for controlling audio playback speed
class AudioSpeedControl extends StatelessWidget {
  /// Current playback speed (0.5 to 2.0)
  final double speed;

  /// Callback when speed changes
  final ValueChanged<double> onSpeedChanged;

  /// Available speed options
  static const List<double> speedOptions = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

  const AudioSpeedControl({
    super.key,
    required this.speed,
    required this.onSpeedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.speed,
          size: 20,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 2.0,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
              overlayShape:
                  const RoundSliderOverlayShape(overlayRadius: 12.0),
            ),
            child: Slider(
              value: speed.clamp(0.5, 2.0),
              min: 0.5,
              max: 2.0,
              divisions: 6,
              label: '${speed}x',
              onChanged: onSpeedChanged,
              activeColor: Theme.of(context).colorScheme.primary,
              inactiveColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${speed}x',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

