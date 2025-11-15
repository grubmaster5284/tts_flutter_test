# TTS Flutter Test

A Flutter application for Text-to-Speech synthesis with support for multiple TTS services (Gemini, OpenAI) and audio playback features.

## Features

- 🎤 **Speech Synthesis**: Convert text to speech using Gemini or OpenAI TTS services
- 🎵 **Audio Playback**: Play audio files with full controls (play, pause, seek, volume, speed)
- 📁 **File Picker**: Load audio files from your device
- ⌨️ **Media Keys**: Support for media keys on desktop platforms (macOS, Windows, Linux)
- ⚙️ **Settings**: Customizable TTS and playback settings

## Architecture

The app uses Python scripts directly via platform channels - **no server required**. See [GUIDE.md](./GUIDE.md#architecture-overview) for details.

## Quick Start

1. **Set up Python scripts** (see [GUIDE.md](./GUIDE.md#setup--installation)):
   - Install Python dependencies
   - Configure API keys in `backend/python/.env`

2. **Run the Flutter app**:
   ```bash
   flutter pub get
   flutter run
   ```

## Documentation

- [GUIDE.md](./GUIDE.md) - Complete guide covering setup, building, testing, and troubleshooting

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
