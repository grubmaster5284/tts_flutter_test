import 'package:flutter_test/flutter_test.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/tts_service_model.dart';

void main() {
  group('TTSServiceModel', () {
    group('enum values', () {
      test('should have all expected service types', () {
        expect(TTSServiceModel.values.length, 3);
        expect(TTSServiceModel.values, contains(TTSServiceModel.gemini));
        expect(TTSServiceModel.values, contains(TTSServiceModel.openai));
        expect(TTSServiceModel.values, contains(TTSServiceModel.polly));
      });
    });

    group('name extension', () {
      test('should return correct name for gemini', () {
        expect(TTSServiceModel.gemini.name, 'Gemini');
      });

      test('should return correct name for openai', () {
        expect(TTSServiceModel.openai.name, 'OpenAI');
      });

      test('should return correct name for polly', () {
        expect(TTSServiceModel.polly.name, 'Amazon Polly');
      });
    });

    group('value extension', () {
      test('should return correct value for gemini', () {
        expect(TTSServiceModel.gemini.value, 'gemini');
      });

      test('should return correct value for openai', () {
        expect(TTSServiceModel.openai.value, 'openai');
      });

      test('should return correct value for polly', () {
        expect(TTSServiceModel.polly.value, 'polly');
      });
    });

    group('fromString factory', () {
      test('should parse lowercase gemini', () {
        expect(TTSServiceModelExtension.fromString('gemini'), TTSServiceModel.gemini);
      });

      test('should parse lowercase openai', () {
        expect(TTSServiceModelExtension.fromString('openai'), TTSServiceModel.openai);
      });

      test('should parse lowercase polly', () {
        expect(TTSServiceModelExtension.fromString('polly'), TTSServiceModel.polly);
      });

      test('should parse uppercase strings', () {
        expect(TTSServiceModelExtension.fromString('GEMINI'), TTSServiceModel.gemini);
        expect(TTSServiceModelExtension.fromString('OPENAI'), TTSServiceModel.openai);
        expect(TTSServiceModelExtension.fromString('POLLY'), TTSServiceModel.polly);
      });

      test('should parse mixed case strings', () {
        expect(TTSServiceModelExtension.fromString('Gemini'), TTSServiceModel.gemini);
        expect(TTSServiceModelExtension.fromString('OpenAI'), TTSServiceModel.openai);
        expect(TTSServiceModelExtension.fromString('Polly'), TTSServiceModel.polly);
      });

      test('should return null for invalid strings', () {
        expect(TTSServiceModelExtension.fromString('invalid'), isNull);
        expect(TTSServiceModelExtension.fromString(''), isNull);
        expect(TTSServiceModelExtension.fromString('google'), isNull);
      });
    });
  });
}

