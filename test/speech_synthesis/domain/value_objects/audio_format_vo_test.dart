import 'package:flutter_test/flutter_test.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/errors/speech_synthesis_error.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/audio_format_vo.dart';

void main() {
  group('AudioFormatVO', () {
    group('validation', () {
      test('should create valid audio format', () {
        final format = AudioFormatVO('mp3');
        
        expect(format.value, 'mp3');
        expect(format.normalizedValue, 'mp3');
      });

      test('should accept all valid formats', () {
        for (final formatStr in AudioFormatVO.validFormats) {
          expect(() => AudioFormatVO(formatStr), returnsNormally,
              reason: 'Should accept format: $formatStr');
          expect(AudioFormatVO(formatStr).normalizedValue, formatStr);
        }
      });

      test('should normalize uppercase to lowercase', () {
        final format = AudioFormatVO('MP3');
        
        expect(format.value, 'MP3');
        expect(format.normalizedValue, 'mp3');
      });

      test('should normalize mixed case to lowercase', () {
        final format = AudioFormatVO('Mp3');
        
        expect(format.normalizedValue, 'mp3');
      });

      test('should throw validation error for empty string', () {
        expect(
          () => AudioFormatVO(''),
          throwsA(isA<SpeechSynthesisError>().having(
            (e) => e.toString(),
            'message',
            contains('cannot be empty'),
          )),
        );
      });

      test('should throw validation error for invalid format', () {
        expect(
          () => AudioFormatVO('invalid'),
          throwsA(isA<SpeechSynthesisError>().having(
            (e) => e.toString(),
            'message',
            contains('must be one of'),
          )),
        );
      });

      test('should throw validation error for unsupported formats', () {
        final unsupported = ['wma', 'm4a', 'aiff', 'webm', 'opus'];
        
        for (final format in unsupported) {
          expect(
            () => AudioFormatVO(format),
            throwsA(isA<SpeechSynthesisError>()),
            reason: 'Should reject format: $format',
          );
        }
      });
    });

    group('equality', () {
      test('should be equal when normalized values are equal', () {
        final format1 = AudioFormatVO('mp3');
        final format2 = AudioFormatVO('MP3');
        
        expect(format1, equals(format2));
        expect(format1.hashCode, equals(format2.hashCode));
      });

      test('should be equal for same format in different cases', () {
        final format1 = AudioFormatVO('WAV');
        final format2 = AudioFormatVO('wav');
        
        expect(format1, equals(format2));
      });

      test('should not be equal for different formats', () {
        final format1 = AudioFormatVO('mp3');
        final format2 = AudioFormatVO('wav');
        
        expect(format1, isNot(equals(format2)));
      });
    });

    group('toString', () {
      test('should return formatted string with original value', () {
        final format = AudioFormatVO('MP3');
        
        expect(format.toString(), 'AudioFormatVO(MP3)');
      });
    });

    group('normalizedValue', () {
      test('should always return lowercase', () {
        expect(AudioFormatVO('MP3').normalizedValue, 'mp3');
        expect(AudioFormatVO('WAV').normalizedValue, 'wav');
        expect(AudioFormatVO('OGG').normalizedValue, 'ogg');
      });
    });
  });
}

