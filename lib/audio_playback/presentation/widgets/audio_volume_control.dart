import 'package:flutter/material.dart';

/// Widget for controlling audio volume
class AudioVolumeControl extends StatelessWidget {
  /// Current volume level (0.0 to 1.0)
  final double volume;

  /// Callback when volume changes
  final ValueChanged<double> onVolumeChanged;

  const AudioVolumeControl({
    super.key,
    required this.volume,
    required this.onVolumeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          _getVolumeIcon(volume),
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
              value: volume.clamp(0.0, 1.0),
              onChanged: onVolumeChanged,
              activeColor: Theme.of(context).colorScheme.primary,
              inactiveColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${(volume * 100).round()}%',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
        ),
      ],
    );
  }

  IconData _getVolumeIcon(double volume) {
    if (volume == 0.0) {
      return Icons.volume_off;
    } else if (volume < 0.5) {
      return Icons.volume_down;
    } else {
      return Icons.volume_up;
    }
  }
}

