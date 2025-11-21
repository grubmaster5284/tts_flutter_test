import 'package:flutter_test/flutter_test.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/speech_request_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/entities/tts_service_model.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/audio_format_vo.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/language_vo.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/text_vo.dart';
import 'package:tts_flutter_test/speech_synthesis/domain/value_objects/voice_vo.dart';

void main() {
  group('SpeechRequestModel', () {
    late TextVO text;
    late TTSServiceModel service;
    late VoiceVO voice;
    late LanguageVO language;
    late AudioFormatVO audioFormat;

    setUp(() {
      text = TextVO('Hello, world!');
      service = TTSServiceModel.gemini;
      voice = VoiceVO('voice-123');
      language = LanguageVO('en');
      audioFormat = AudioFormatVO('mp3');
    });

    group('construction', () {
      test('should create with required fields', () {
        final request = SpeechRequestModel(
          text: text,
          service: service,
        );

        expect(request.text, text);
        expect(request.service, service);
        expect(request.voice, isNull);
        expect(request.language, isNull);
        expect(request.audioFormat, isNull);
      });

      test('should create with all fields', () {
        final request = SpeechRequestModel(
          text: text,
          service: service,
          voice: voice,
          language: language,
          audioFormat: audioFormat,
        );

        expect(request.text, text);
        expect(request.service, service);
        expect(request.voice, voice);
        expect(request.language, language);
        expect(request.audioFormat, audioFormat);
      });

      test('should create with partial optional fields', () {
        final request = SpeechRequestModel(
          text: text,
          service: service,
          voice: voice,
        );

        expect(request.text, text);
        expect(request.service, service);
        expect(request.voice, voice);
        expect(request.language, isNull);
        expect(request.audioFormat, isNull);
      });
    });

    group('withDefaults factory', () {
      test('should create with default audio format when not provided', () {
        final request = SpeechRequestModel.withDefaults(
          text: text,
          service: service,
        );

        expect(request.text, text);
        expect(request.service, service);
        expect(request.audioFormat, isNotNull);
        expect(request.audioFormat!.normalizedValue, 'mp3');
      });

      test('should use provided audio format when given', () {
        final customFormat = AudioFormatVO('wav');
        final request = SpeechRequestModel.withDefaults(
          text: text,
          service: service,
          audioFormat: customFormat,
        );

        expect(request.audioFormat, customFormat);
      });

      test('should preserve all provided fields', () {
        final request = SpeechRequestModel.withDefaults(
          text: text,
          service: service,
          voice: voice,
          language: language,
          audioFormat: audioFormat,
        );

        expect(request.text, text);
        expect(request.service, service);
        expect(request.voice, voice);
        expect(request.language, language);
        expect(request.audioFormat, audioFormat);
      });
    });

    group('copyWith', () {
      test('should create copy with modified fields', () {
        final original = SpeechRequestModel(
          text: text,
          service: service,
        );

        final newText = TextVO('New text');
        final copied = original.copyWith(text: newText);

        expect(copied.text, newText);
        expect(copied.service, service);
        expect(copied.voice, isNull);
      });

      test('should create copy with added optional fields', () {
        final original = SpeechRequestModel(
          text: text,
          service: service,
        );

        final copied = original.copyWith(
          voice: voice,
          language: language,
        );

        expect(copied.text, text);
        expect(copied.service, service);
        expect(copied.voice, voice);
        expect(copied.language, language);
      });

      test('should create copy with null optional fields', () {
        final original = SpeechRequestModel(
          text: text,
          service: service,
          voice: voice,
        );

        final copied = original.copyWith(voice: null);

        expect(copied.voice, isNull);
      });
    });

    group('equality', () {
      test('should be equal when all fields are equal', () {
        final request1 = SpeechRequestModel(
          text: text,
          service: service,
          voice: voice,
          language: language,
          audioFormat: audioFormat,
        );

        final request2 = SpeechRequestModel(
          text: text,
          service: service,
          voice: voice,
          language: language,
          audioFormat: audioFormat,
        );

        expect(request1, equals(request2));
      });

      test('should not be equal when text differs', () {
        final request1 = SpeechRequestModel(
          text: text,
          service: service,
        );

        final request2 = SpeechRequestModel(
          text: TextVO('Different text'),
          service: service,
        );

        expect(request1, isNot(equals(request2)));
      });

      test('should not be equal when service differs', () {
        final request1 = SpeechRequestModel(
          text: text,
          service: TTSServiceModel.gemini,
        );

        final request2 = SpeechRequestModel(
          text: text,
          service: TTSServiceModel.openai,
        );

        expect(request1, isNot(equals(request2)));
      });
    });

    group('immutability', () {
      test('should be immutable', () {
        final request = SpeechRequestModel(
          text: text,
          service: service,
        );

        // copyWith should create a new instance
        final copied = request.copyWith(voice: voice);

        expect(request.voice, isNull);
        expect(copied.voice, voice);
        expect(request, isNot(same(copied)));
      });
    });
  });
}

