# TTS Flutter Test - Complete Guide

This guide contains all the information you need to set up, build, test, and use the TTS Flutter Test application.

---

## Table of Contents

1. [Setup & Installation](#setup--installation)
2. [Architecture Overview](#architecture-overview)
3. [Building the App](#building-the-app)
4. [Testing](#testing)
5. [Google Cloud Setup](#google-cloud-setup)
6. [Logging](#logging)
7. [Troubleshooting](#troubleshooting)

---

## Setup & Installation

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- API keys for TTS services (Gemini and/or OpenAI)

### Environment Configuration

The app uses pure Dart HTTP clients to make direct API calls - **no Python scripts or backend server required**.

#### 1. Configure API Keys

Copy the example environment file and add your credentials:

```bash
cp .env.example .env
```

Edit `.env` and add your API keys. See [ENV_SETUP.md](./ENV_SETUP.md) for detailed instructions.

**For Google Cloud TTS (Gemini):**
- Option 1: Add full service account JSON to `.env`:
  ```env
  GOOGLE_SERVICE_ACCOUNT_JSON={"type":"service_account",...}
  ```
- Option 2: Set path to service account key file:
  ```env
  GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account-key.json
  ```

**For OpenAI TTS:**
```env
OPENAI_API_KEY=sk-your-openai-api-key-here
```

**Note**: You need at least one API key to use the corresponding service.

### Flutter Setup

```bash
flutter pub get
flutter run
```

The app will automatically load environment variables from `.env` on startup.

---

## Architecture Overview

### Pure Dart HTTP Architecture

The app uses **pure Dart HTTP clients** to make direct API calls to TTS services. This eliminates the need for Python scripts, platform channels, or a backend server. All platforms (web, desktop, mobile) use the same Dart implementation.

**Flow:**
```
Flutter App
    ↓
Repository (checks cache)
    ↓
TTS Service Factory (creates appropriate service)
    ↓
Pure Dart TTS Service (GeminiTtsRemoteService / OpenAITtsRemoteService)
    ↓
Direct HTTP Call to TTS API (Google Cloud / OpenAI)
    ↓
Audio Response (base64)
    ↓
Flutter (saves to file, caches response)
    ↓
Audio Player (plays file)
```

### Key Components

- **TtsServiceFactory**: Factory pattern for creating appropriate TTS service instances
- **GeminiTtsRemoteService**: Pure Dart service for Google Cloud Text-to-Speech API
- **OpenAITtsRemoteService**: Pure Dart service for OpenAI TTS API
- **PollyTtsRemoteService**: Placeholder for future AWS Polly implementation
- **Repository**: Coordinates services, handles caching, and manages file storage
- **Local Service**: Handles caching in SharedPreferences to avoid redundant API calls

### Benefits

1. ✅ **No External Dependencies** - No Python, no scripts, no backend server
2. ✅ **Cross-Platform Consistency** - Same code works on all platforms (web, desktop, mobile)
3. ✅ **Simpler Deployment** - Everything in one Flutter app
4. ✅ **Better Performance** - Direct HTTP calls, no intermediate layers
5. ✅ **Easier Maintenance** - Pure Dart codebase, easier to test and debug
6. ✅ **Web Support** - Works natively on web without platform channel limitations

---

## Building the App

### Prerequisites by Platform

#### iOS
- macOS (required for iOS builds)
- Xcode (latest version recommended)
- CocoaPods (`sudo gem install cocoapods`)

#### Android
- Android Studio
- Android SDK (API level 21 or higher)
- Java Development Kit (JDK) 11 or higher

#### Linux
```bash
sudo apt-get update
sudo apt-get install -y \
  clang \
  cmake \
  ninja-build \
  pkg-config \
  libgtk-3-dev \
  liblzma-dev
```

#### Windows
- Windows 10 or higher
- Visual Studio 2019 or higher with:
  - Desktop development with C++
  - Windows 10/11 SDK

### Build Commands

**Verify Flutter Setup:**
```bash
flutter doctor
```

**Get Dependencies:**
```bash
flutter pub get
```

**Platform-Specific Builds:**

```bash
# Android
flutter build apk --release

# iOS (macOS only)
flutter build ios --release

# Linux
flutter build linux --release

# Windows
flutter build windows --release
```

**Run on Device/Emulator:**
```bash
flutter run
```

### Platform-Specific Features

**Media Key Support:**
- ✅ macOS - Supported
- ✅ Linux - Supported
- ✅ Windows - Supported
- ❌ iOS - Not available (gracefully skipped)
- ❌ Android - Not available (gracefully skipped)

**Audio Playback:**
- ✅ All platforms - Supported via `audioplayers` package

**File Picker:**
- ✅ All platforms - Supported via `file_picker` package

---

## Testing

### Pre-Testing Setup

- [ ] Environment variables configured in `.env` file
- [ ] Google Cloud service account JSON or OpenAI API key added
- [ ] Flutter app launched and running
- [ ] Internet connection available

### Quick Test Checklist

#### Audio Playback Tests
- [ ] Load audio from URL
- [ ] Load audio from file picker
- [ ] Play/Pause/Stop controls work
- [ ] Progress bar seeking works
- [ ] Volume control adjusts audio
- [ ] Playback speed control works
- [ ] Compact mode toggle works
- [ ] Media key play/pause works (desktop)
- [ ] Media key fast forward works (desktop)
- [ ] Media key rewind works (desktop)
- [ ] Media key volume up/down works (desktop)

#### Speech Synthesis Tests
- [ ] Basic text-to-speech conversion works
- [ ] Service selection (Gemini/OpenAI) works
- [ ] Voice selection works
- [ ] Language selection works
- [ ] Audio format selection works
- [ ] Empty text validation prevents submission
- [ ] Long text (1000+ chars) handled correctly
- [ ] API call failure shows appropriate error
- [ ] Invalid credentials show error
- [ ] Generated audio plays in player

#### Media Keys Testing (Desktop Only)

**Supported Keys:**
- **Play/Pause**: Toggles playback
- **Fast Forward**: Advances by 10 seconds
- **Rewind**: Goes back 10 seconds
- **Volume Up**: Increases volume by 5%
- **Volume Down**: Decreases volume by 5%

**Quick Test:**
1. Load an audio file
2. Start playing
3. Test each media key
4. Verify UI updates in real-time

**Platform-Specific Keys:**
- **macOS**: F8 (play/pause), F9 (forward), F7 (rewind), F12/F11 (volume)
- **Windows**: Usually F8, F9, F7, F12/F11
- **Linux**: XF86AudioPlay, XF86AudioNext, XF86AudioPrev, XF86AudioRaiseVolume/LowerVolume

### Test Commands

**Sample Audio URL for Testing:**
- MP3: `https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3`

**Note**: The app now uses pure Dart HTTP clients, so there are no separate Python scripts to test. All TTS functionality is tested through the Flutter app UI.

---

## Google Cloud Setup

The Gemini TTS service uses Google Cloud Text-to-Speech API, which requires OAuth2 authentication via service account credentials.

### Service Account Setup (Recommended)

**This is the recommended method** for all platforms (web, desktop, mobile).

1. **Create a Service Account:**
   - Go to [Google Cloud Console](https://console.cloud.google.com/iam-admin/serviceaccounts)
   - Click "Create Service Account"
   - Give it a name (e.g., "tts-service")
   - Click "Create and Continue"

2. **Grant Permissions:**
   - Select role: **Cloud Text-to-Speech API User**
   - Click "Continue" then "Done"

3. **Create and Download Key:**
   - Click on the service account
   - Go to the "Keys" tab
   - Click "Add Key" → "Create new key"
   - Choose "JSON" format
   - Download the key file

4. **Configure the Key File:**
   
   You have two options:
   
   **Option 1: Add JSON to `.env` file (Recommended)**
   - Minify the JSON: `cat service-account-key.json | jq -c .`
   - Add to `.env`:
     ```env
     GOOGLE_SERVICE_ACCOUNT_JSON={"type":"service_account",...}
     ```
   
   **Option 2: Use File Path**
   - Place the JSON file in project root or set environment variable:
     ```env
     GOOGLE_APPLICATION_CREDENTIALS=/path/to/service-account-key.json
     ```
   
   See [ENV_SETUP.md](./ENV_SETUP.md) for detailed configuration instructions.

### Enable the Text-to-Speech API

1. Go to [Google Cloud Console APIs](https://console.cloud.google.com/apis/library/texttospeech.googleapis.com)
2. Select your project
3. Click "Enable"

### Troubleshooting

**Error: "Google Cloud credentials not found"**
- Make sure `.env` file exists in project root
- Verify `GOOGLE_SERVICE_ACCOUNT_JSON` is set in `.env` (minified JSON on single line)
- Or set `GOOGLE_APPLICATION_CREDENTIALS` to path of service account key file
- See [ENV_SETUP.md](./ENV_SETUP.md) for detailed troubleshooting

**Error: "API keys are not supported"**
- Google Cloud TTS requires OAuth2 service account credentials, not API keys
- Use Service Account setup (see above)

**Error: "The Text-to-Speech API has not been used"**
- Enable the Text-to-Speech API in Google Cloud Console (see "Enable the Text-to-Speech API" above)

**Error: "Permission denied"**
- Make sure your service account has the "Cloud Text-to-Speech API User" role

**Error persists after setting up credentials:**
- Verify the JSON in `.env` is properly escaped and minified
- Check that the Text-to-Speech API is enabled in your Google Cloud project
- Restart the app after changing `.env` (hot reload may not pick up changes)

---

## Logging

This project uses the `logger` package for comprehensive logging throughout the application.

### Quick Start

```dart
import 'package:tts_flutter_test/core/utils/logger.dart';

AppLogger.info('This is an info message');
AppLogger.error('This is an error', error: e, stackTrace: stackTrace);
AppLogger.debug('Debug information', data: someData);
```

### Log Levels

- **`debug`** - Detailed information for development
- **`info`** - Informational messages about app progress
- **`warning`** - Potentially harmful situations
- **`error`** - Error events that might allow the app to continue
- **`fatal`** - Very severe errors that might cause the app to abort
- **`verbose`** - Very detailed information, typically for diagnostics

### Usage Examples

```dart
// Basic logging
AppLogger.info('User logged in', tag: 'Auth');
AppLogger.debug('Processing request', tag: 'API');

// Error logging with stack trace
try {
  // some code
} catch (e, stackTrace) {
  AppLogger.error('Failed to load data', 
      tag: 'DataLoader',
      error: e,
      stackTrace: stackTrace);
}

// Logging with data
AppLogger.debug('Audio loaded', 
    tag: 'AudioPlayer', 
    data: {
      'source': audioSource,
      'duration': duration,
    });
```

### Viewing Logs

**In Development:**
```bash
flutter run
flutter logs
```

**Filtering Logs:**
```bash
# Filter by tag
flutter logs | grep "AudioPlayer"

# Filter by level (errors only)
flutter logs | grep "ERROR"
```

### Common Log Tags

- `AudioPlayer` - Audio playback related logs
- `FilePicker` - File selection operations
- `MediaKeys` - Media key events
- `TTSRepository` - TTS repository operations
- `TTSRemoteService` - TTS service calls

---

## Troubleshooting

### API Configuration Issues

**Error: `OPENAI_API_KEY` not found**
- Create `.env` file in project root (copy from `.env.example`)
- Add `OPENAI_API_KEY=sk-your-key-here` to `.env`
- Restart the app after changing `.env`

**Error: `GOOGLE_SERVICE_ACCOUNT_JSON` not found or invalid**
- Add service account JSON to `.env` file (minified, single line)
- Or set `GOOGLE_APPLICATION_CREDENTIALS` to path of key file
- Verify JSON is properly escaped in `.env`
- See [ENV_SETUP.md](./ENV_SETUP.md) for detailed instructions

**Error: API calls failing**
- Check internet connection
- Verify API keys are valid and have proper permissions
- Check app logs for detailed error messages

### Build Issues

**Android - NDK errors:**
```bash
flutter clean
flutter pub get
flutter run
```

**iOS - Runtime version mismatch:**
- Open Xcode
- Go to **Xcode → Settings → Components**
- Download and install the required iOS runtime version

**iOS - Pod install failed:**
```bash
cd ios
pod deintegrate
pod install
cd ..
```

**Linux - Missing dependencies:**
```bash
sudo apt-get update
sudo apt-get install -y \
  clang cmake ninja-build pkg-config \
  libgtk-3-dev liblzma-dev
```

### Media Keys Not Working

1. Check Platform: Must be macOS, Windows, or Linux
2. Check Focus: App window must be active
3. Check Logs: Look for `MediaKeyHandler initialized`
4. Check Keyboard: Test if keys work in other apps

### File Picker Issues

1. Check Permissions: macOS may need file access permissions
2. Check Logs: Look for `[FilePicker]` messages
3. Check File Format: Ensure file is a supported audio format

### General Issues

1. **Check Logs**: Always check console output first
2. **Restart App**: Sometimes fixes initialization issues
3. **Check Dependencies**: Run `flutter pub get`
4. **Clean Build**: Run `flutter clean` and rebuild

---

## Additional Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Google Cloud TTS Documentation](https://cloud.google.com/text-to-speech/docs)
- [OpenAI TTS Documentation](https://platform.openai.com/docs/guides/text-to-speech)
- [ENV_SETUP.md](./ENV_SETUP.md) - Detailed environment variable configuration guide

