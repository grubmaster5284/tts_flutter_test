import 'package:flutter_test/flutter_test.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_response_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/audio_format_vo.dart';

void main() {
  group('SpeechResponseModel', () {
    late String audioData;
    late AudioFormatVO audioFormat;
    late int durationMs;

    setUp(() {
      audioData = 'base64encodedaudiodata';
      audioFormat = AudioFormatVO('mp3');
      durationMs = 5000;
    });

    group('construction', () {
      test('should create with required fields', () {
        final response = SpeechResponseModel(
          audioData: audioData,
          audioFormat: audioFormat,
          durationMs: durationMs,
        );

        expect(response.audioData, audioData);
        expect(response.audioFormat, audioFormat);
        expect(response.durationMs, durationMs);
        expect(response.metadata, isNull);
      });

      test('should create with all fields including metadata', () {
        const metadata = '{"sampleRate": 44100, "channels": 2}';
        final response = SpeechResponseModel(
          audioData: audioData,
          audioFormat: audioFormat,
          durationMs: durationMs,
          metadata: metadata,
        );

        expect(response.audioData, audioData);
        expect(response.audioFormat, audioFormat);
        expect(response.durationMs, durationMs);
        expect(response.metadata, metadata);
      });

      test('should accept different audio formats', () {
        final formats = ['mp3', 'wav', 'ogg', 'aac', 'flac'];
        
        for (final formatStr in formats) {
          final format = AudioFormatVO(formatStr);
          final response = SpeechResponseModel(
            audioData: audioData,
            audioFormat: format,
            durationMs: durationMs,
          );

          expect(response.audioFormat, format);
        }
      });

      test('should accept different duration values', () {
        final durations = [0, 100, 1000, 5000, 60000];
        
        for (final duration in durations) {
          final response = SpeechResponseModel(
            audioData: audioData,
            audioFormat: audioFormat,
            durationMs: duration,
          );

          expect(response.durationMs, duration);
        }
      });
    });

    group('copyWith', () {
      test('should create copy with modified fields', () {
        final original = SpeechResponseModel(
          audioData: audioData,
          audioFormat: audioFormat,
          durationMs: durationMs,
        );

        final newAudioData = 'newaudiodata';
        final copied = original.copyWith(audioData: newAudioData);

        expect(copied.audioData, newAudioData);
        expect(copied.audioFormat, audioFormat);
        expect(copied.durationMs, durationMs);
      });

      test('should create copy with added metadata', () {
        final original = SpeechResponseModel(
          audioData: audioData,
          audioFormat: audioFormat,
          durationMs: durationMs,
        );

        const metadata = '{"key": "value"}';
        final copied = original.copyWith(metadata: metadata);

        expect(copied.metadata, metadata);
      });

      test('should create copy with null metadata', () {
        final original = SpeechResponseModel(
          audioData: audioData,
          audioFormat: audioFormat,
          durationMs: durationMs,
          metadata: '{"key": "value"}',
        );

        final copied = original.copyWith(metadata: null);

        expect(copied.metadata, isNull);
      });
    });

    group('equality', () {
      test('should be equal when all fields are equal', () {
        final response1 = SpeechResponseModel(
          audioData: audioData,
          audioFormat: audioFormat,
          durationMs: durationMs,
        );

        final response2 = SpeechResponseModel(
          audioData: audioData,
          audioFormat: audioFormat,
          durationMs: durationMs,
        );

        expect(response1, equals(response2));
      });

      test('should not be equal when audioData differs', () {
        final response1 = SpeechResponseModel(
          audioData: audioData,
          audioFormat: audioFormat,
          durationMs: durationMs,
        );

        final response2 = SpeechResponseModel(
          audioData: 'differentdata',
          audioFormat: audioFormat,
          durationMs: durationMs,
        );

        expect(response1, isNot(equals(response2)));
      });

      test('should not be equal when duration differs', () {
        final response1 = SpeechResponseModel(
          audioData: audioData,
          audioFormat: audioFormat,
          durationMs: durationMs,
        );

        final response2 = SpeechResponseModel(
          audioData: audioData,
          audioFormat: audioFormat,
          durationMs: 10000,
        );

        expect(response1, isNot(equals(response2)));
      });
    });
  });
}

