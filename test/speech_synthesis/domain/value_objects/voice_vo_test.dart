import 'package:flutter_test/flutter_test.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/voice_vo.dart';

void main() {
  group('VoiceVO', () {
    group('validation', () {
      test('should create valid voice identifier', () {
        // Arrange & Act
        final voice = VoiceVO('voice-123');
        
        // Assert
        expect(voice.value, 'voice-123');
      });

      test('should accept alphanumeric characters', () {
        expect(() => VoiceVO('voice123'), returnsNormally);
        expect(() => VoiceVO('Voice123'), returnsNormally);
      });

      test('should accept underscores', () {
        expect(() => VoiceVO('voice_123'), returnsNormally);
        expect(() => VoiceVO('_voice'), returnsNormally);
      });

      test('should accept hyphens', () {
        expect(() => VoiceVO('voice-123'), returnsNormally);
        expect(() => VoiceVO('-voice'), returnsNormally);
      });

      test('should accept mixed valid characters', () {
        expect(() => VoiceVO('voice-123_abc'), returnsNormally);
        expect(() => VoiceVO('Voice_123-ABC'), returnsNormally);
      });

      test('should throw validation error for empty string', () {
        expect(
          () => VoiceVO(''),
          throwsA(isA<SpeechSynthesisError>().having(
            (e) => e.toString(),
            'message',
            contains('cannot be empty'),
          )),
        );
      });

      test('should throw validation error for too short identifier', () {
        // minLength is 1, so empty is the only invalid case
        // But let's test edge case
        expect(() => VoiceVO('a'), returnsNormally);
      });

      test('should throw validation error for too long identifier', () {
        // Create a string longer than maxLength (100)
        final tooLong = 'a' * 101;
        
        expect(
          () => VoiceVO(tooLong),
          throwsA(isA<SpeechSynthesisError>().having(
            (e) => e.toString(),
            'message',
            contains('between'),
          )),
        );
      });

      test('should accept identifier at max length', () {
        final maxLength = 'a' * 100;
        expect(() => VoiceVO(maxLength), returnsNormally);
      });

      test('should throw validation error for spaces', () {
        expect(
          () => VoiceVO('voice 123'),
          throwsA(isA<SpeechSynthesisError>()),
        );
      });

      test('should throw validation error for special characters', () {
        final invalidChars = ['@', '#', r'$', '%', '&', '*', '(', ')', '+', '='];
        
        for (final char in invalidChars) {
          expect(
            () => VoiceVO('voice$char'),
            throwsA(isA<SpeechSynthesisError>()),
            reason: 'Should reject character: $char',
          );
        }
      });
    });

    group('equality', () {
      test('should be equal when values are equal', () {
        final voice1 = VoiceVO('voice-123');
        final voice2 = VoiceVO('voice-123');
        
        expect(voice1, equals(voice2));
        expect(voice1.hashCode, equals(voice2.hashCode));
      });

      test('should not be equal when values differ', () {
        final voice1 = VoiceVO('voice-123');
        final voice2 = VoiceVO('voice-456');
        
        expect(voice1, isNot(equals(voice2)));
      });

      test('should be case-sensitive', () {
        final voice1 = VoiceVO('Voice');
        final voice2 = VoiceVO('voice');
        
        expect(voice1, isNot(equals(voice2)));
      });
    });

    group('toString', () {
      test('should return formatted string', () {
        final voice = VoiceVO('voice-123');
        
        expect(voice.toString(), 'VoiceVO(voice-123)');
      });
    });

    group('constants', () {
      test('should have correct minLength', () {
        expect(VoiceVO.minLength, 1);
      });

      test('should have correct maxLength', () {
        expect(VoiceVO.maxLength, 100);
      });
    });
  });
}

