import 'package:flutter_test/flutter_test.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/text_vo.dart';

void main() {
  group('TextVO', () {
    group('validation', () {
      test('should create valid text', () {
        final text = TextVO('Hello, world!');
        
        expect(text.value, 'Hello, world!');
      });

      test('should accept text at minimum length', () {
        expect(() => TextVO('H'), returnsNormally);
      });

      test('should accept text at maximum length', () {
        final maxText = 'a' * TextVO.maxLength;
        expect(() => TextVO(maxText), returnsNormally);
      });

      test('should accept text within valid range', () {
        expect(() => TextVO('Hello'), returnsNormally);
        expect(() => TextVO('This is a longer text that should be valid'), returnsNormally);
      });

      test('should throw validation error for empty string', () {
        expect(
          () => TextVO(''),
          throwsA(isA<SpeechSynthesisError>().having(
            (e) => e.toString(),
            'message',
            contains('cannot be empty'),
          )),
        );
      });

      test('should throw validation error for text exceeding max length', () {
        final tooLong = 'a' * (TextVO.maxLength + 1);
        
        expect(
          () => TextVO(tooLong),
          throwsA(isA<SpeechSynthesisError>().having(
            (e) => e.toString(),
            'message',
            contains('must not exceed'),
          )),
        );
      });

      test('should accept text with special characters', () {
        expect(() => TextVO(r'Hello, world! @#$%'), returnsNormally);
      });

      test('should accept text with newlines', () {
        expect(() => TextVO('Line 1\nLine 2'), returnsNormally);
      });

      test('should accept text with unicode characters', () {
        expect(() => TextVO('Hello 世界'), returnsNormally);
      });
    });

    group('equality', () {
      test('should be equal when values are equal', () {
        final text1 = TextVO('Hello');
        final text2 = TextVO('Hello');
        
        expect(text1, equals(text2));
        expect(text1.hashCode, equals(text2.hashCode));
      });

      test('should not be equal when values differ', () {
        final text1 = TextVO('Hello');
        final text2 = TextVO('World');
        
        expect(text1, isNot(equals(text2)));
      });

      test('should be case-sensitive', () {
        final text1 = TextVO('Hello');
        final text2 = TextVO('hello');
        
        expect(text1, isNot(equals(text2)));
      });
    });

    group('toString', () {
      test('should return formatted string', () {
        final text = TextVO('Hello');
        
        expect(text.toString(), 'TextVO(Hello)');
      });
    });

    group('constants', () {
      test('should have correct minLength', () {
        expect(TextVO.minLength, 1);
      });

      test('should have correct maxLength', () {
        expect(TextVO.maxLength, 5000);
      });
    });
  });
}

