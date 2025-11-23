# TTS Flutter Test

A Flutter application for Text-to-Speech synthesis with support for multiple TTS services (Gemini, OpenAI) and audio playback features.

## Features

- 🎤 **Speech Synthesis**: Convert text to speech using Gemini or OpenAI TTS services
- 🎵 **Audio Playback**: Play audio files with full controls (play, pause, seek, volume, speed)
- 📁 **File Picker**: Load audio files from your device
- ⌨️ **Media Keys**: Support for media keys on desktop platforms (macOS, Windows, Linux)
- ⚙️ **Settings**: Customizable TTS and playback settings

## Architecture

The app uses **pure Dart HTTP clients** to make direct API calls to TTS services - **no Python scripts or backend server required**. All platforms (web, desktop, mobile) use the same Dart implementation. See [GUIDE.md](./GUIDE.md#architecture-overview) for details.

## Quick Start

1. **Configure API keys** (see [ENV_SETUP.md](./ENV_SETUP.md)):
   - Copy `.env.example` to `.env`
   - Add your Google Cloud service account JSON and/or OpenAI API key

2. **Run the Flutter app**:
   ```bash
   flutter pub get
   flutter run
   ```

## Documentation

- [GUIDE.md](./GUIDE.md) - Complete guide covering setup, building, testing, and troubleshooting
- [ENV_SETUP.md](./ENV_SETUP.md) - Environment variables and API key configuration guide

## Platform Support

- ✅ macOS
- ✅ iOS
- ✅ Android
- ✅ Linux
- ✅ Windows
- ✅ Web

## Getting Started with Flutter

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
