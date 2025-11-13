import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tts_flutter_test/settings/application/providers/settings_providers.dart';

/// Settings widget with various configuration options
class SettingsWidget extends ConsumerWidget {
  const SettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsStateProvider);
    final settingsNotifier = ref.read(settingsNotifierRefProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // TTS Settings Section
        _buildSection(
          context,
          title: 'TTS Settings',
          icon: Icons.volume_up,
          children: [
            _buildDropdownSetting(
              context,
              label: 'Default TTS Service',
              value: settingsState.defaultTtsService,
              items: const ['gemini', 'openai', 'polly'],
              onChanged: (value) {
                if (value != null) {
                  settingsNotifier.updateDefaultTtsService(value);
                }
              },
            ),
            _buildTextFieldSetting(
              context,
              label: 'Default Voice',
              value: settingsState.defaultVoice ?? '',
              hintText: 'Enter voice identifier',
              onChanged: (value) {
                settingsNotifier.updateDefaultVoice(
                  value.isEmpty ? null : value,
                );
              },
            ),
            _buildTextFieldSetting(
              context,
              label: 'Default Language',
              value: settingsState.defaultLanguage,
              hintText: 'e.g., en, es, fr',
              onChanged: (value) {
                if (value.isNotEmpty) {
                  settingsNotifier.updateDefaultLanguage(value);
                }
              },
            ),
            _buildDropdownSetting(
              context,
              label: 'Default Audio Format',
              value: settingsState.defaultAudioFormat,
              items: const ['mp3', 'wav', 'ogg', 'aac', 'flac'],
              onChanged: (value) {
                if (value != null) {
                  settingsNotifier.updateDefaultAudioFormat(value);
                }
              },
            ),
          ],
        ),

        // Playback Settings Section
        _buildSection(
          context,
          title: 'Playback Settings',
          icon: Icons.play_circle_outline,
          children: [
            _buildSliderSetting(
              context,
              label: 'Default Volume',
              value: settingsState.defaultVolume,
              min: 0.0,
              max: 1.0,
              divisions: 10,
              formatValue: (value) => '${(value * 100).toInt()}%',
              onChanged: (value) {
                settingsNotifier.updateDefaultVolume(value);
              },
            ),
            _buildSliderSetting(
              context,
              label: 'Default Playback Speed',
              value: settingsState.defaultPlaybackSpeed,
              min: 0.5,
              max: 2.0,
              divisions: 15,
              formatValue: (value) => '${value.toStringAsFixed(1)}x',
              onChanged: (value) {
                settingsNotifier.updateDefaultPlaybackSpeed(value);
              },
            ),
          ],
        ),

        // Appearance Settings Section
        _buildSection(
          context,
          title: 'Appearance',
          icon: Icons.palette_outlined,
          children: [
            _buildDropdownSetting(
              context,
              label: 'Theme Preference',
              value: settingsState.themePreference,
              items: const ['light', 'dark', 'system'],
              onChanged: (value) {
                if (value != null) {
                  settingsNotifier.updateThemePreference(value);
                }
              },
            ),
          ],
        ),

        // Actions Section
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FilledButton.icon(
                    onPressed: () => settingsNotifier.resetToDefaults(),
                    icon: const Icon(Icons.restore),
                    label: const Text('Reset to Defaults'),
                    style: FilledButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(icon, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownSetting(
    BuildContext context, {
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return ListTile(
      title: Text(label),
      trailing: DropdownButton<String>(
        value: value,
        items: items.map((item) {
          return DropdownMenuItem<String>(
            value: item,
            child: Text(item.toUpperCase()),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildTextFieldSetting(
    BuildContext context, {
    required String label,
    required String value,
    required String hintText,
    required ValueChanged<String> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: const OutlineInputBorder(),
        ),
        controller: TextEditingController(text: value)
          ..selection = TextSelection.fromPosition(
            TextPosition(offset: value.length),
          ),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildSliderSetting(
    BuildContext context, {
    required String label,
    required double value,
    required double min,
    required double max,
    required int divisions,
    required String Function(double) formatValue,
    required ValueChanged<double> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                formatValue(value),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          Slider(
            value: value,
            min: min,
            max: max,
            divisions: divisions,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

