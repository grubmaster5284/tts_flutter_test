import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tts_flutter_test/speech_synthesis/presentation/controllers/speech_synthesis_ui_provider.dart';

/// Widget for selecting language
class LanguageSelectorWidget extends ConsumerWidget {
  const LanguageSelectorWidget({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLanguage = ref.watch(selectedLanguageProvider);
    
    // Common languages in ISO 639-1 format
    final languages = [
      {'code': 'en', 'name': 'English'},
      {'code': 'es', 'name': 'Spanish'},
      {'code': 'fr', 'name': 'French'},
      {'code': 'de', 'name': 'German'},
      {'code': 'it', 'name': 'Italian'},
      {'code': 'pt', 'name': 'Portuguese'},
      {'code': 'ru', 'name': 'Russian'},
      {'code': 'ja', 'name': 'Japanese'},
      {'code': 'ko', 'name': 'Korean'},
      {'code': 'zh', 'name': 'Chinese'},
    ];
    
    return DropdownButtonFormField<String>(
      initialValue: selectedLanguage,
      decoration: const InputDecoration(
        labelText: 'Language (Optional)',
        border: OutlineInputBorder(),
      ),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('Auto-detect'),
        ),
        ...languages.map((lang) {
          return DropdownMenuItem<String>(
            value: lang['code'],
            child: Text('${lang['name']} (${lang['code']})'),
          );
        }),
      ],
      onChanged: (language) {
        ref.read(selectedLanguageProvider.notifier).state = language;
      },
    );
  }
}

