import 'package:flutter_test/flutter_test.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/language_vo.dart';

void main() {
  group('LanguageVO', () {
    group('validation', () {
      test('should create valid language code', () {
        // Arrange & Act
        final language = LanguageVO('en');
        
        // Assert
        expect(language.value, 'en');
      });

      test('should accept valid ISO 639-1 codes', () {
        final validCodes = ['en', 'es', 'fr', 'de', 'it', 'pt', 'ru', 'ja', 'zh', 'ar'];
        
        for (final code in validCodes) {
          expect(() => LanguageVO(code), returnsNormally,
              reason: 'Should accept valid code: $code');
          expect(LanguageVO(code).value, code);
        }
      });

      test('should throw validation error for empty string', () {
        // Arrange & Act & Assert
        expect(
          () => LanguageVO(''),
          throwsA(isA<SpeechSynthesisError>().having(
            (e) => e.toString(),
            'message',
            contains('cannot be empty'),
          )),
        );
      });

      test('should throw validation error for code with wrong length', () {
        // Test too short
        expect(
          () => LanguageVO('e'),
          throwsA(isA<SpeechSynthesisError>().having(
            (e) => e.toString(),
            'message',
            contains('exactly'),
          )),
        );

        // Test too long
        expect(
          () => LanguageVO('eng'),
          throwsA(isA<SpeechSynthesisError>().having(
            (e) => e.toString(),
            'message',
            contains('exactly'),
          )),
        );
      });

      test('should throw validation error for uppercase letters', () {
        expect(
          () => LanguageVO('EN'),
          throwsA(isA<SpeechSynthesisError>()),
        );
      });

      test('should throw validation error for numbers', () {
        expect(
          () => LanguageVO('e1'),
          throwsA(isA<SpeechSynthesisError>()),
        );
      });

      test('should throw validation error for special characters', () {
        expect(
          () => LanguageVO('e-'),
          throwsA(isA<SpeechSynthesisError>()),
        );
      });
    });

    group('equality', () {
      test('should be equal when values are equal', () {
        // Arrange
        final language1 = LanguageVO('en');
        final language2 = LanguageVO('en');
        
        // Assert
        expect(language1, equals(language2));
        expect(language1.hashCode, equals(language2.hashCode));
      });

      test('should not be equal when values differ', () {
        // Arrange
        final language1 = LanguageVO('en');
        final language2 = LanguageVO('es');
        
        // Assert
        expect(language1, isNot(equals(language2)));
      });

      test('should not be equal to different type', () {
        // Arrange
        final language = LanguageVO('en');
        
        // Assert
        expect(language, isNot(equals('en')));
      });
    });

    group('toString', () {
      test('should return formatted string', () {
        // Arrange
        final language = LanguageVO('en');
        
        // Assert
        expect(language.toString(), 'LanguageVO(en)');
      });
    });

    group('immutability', () {
      test('should have constant length property', () {
        // Assert
        expect(LanguageVO.length, 2);
      });
    });
  });
}

