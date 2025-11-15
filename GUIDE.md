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
- Python 3 installed on system (`/usr/bin/python3` on macOS)
- API keys for TTS services (Gemini and/or OpenAI)

### Python Scripts Setup

The app uses Python scripts directly via platform channels - **no server required**.

#### 1. Install Python Dependencies

**Option 1: Use existing virtual environment (recommended)**

If you already have a virtual environment set up:

```bash
cd backend/python
source venv/bin/activate
pip install -r ../../scripts/requirements.txt
```

**Option 2: Create new virtual environment**

If you don't have a virtual environment:

```bash
cd backend/python
python3 -m venv venv
source venv/bin/activate
pip install -r ../../scripts/requirements.txt
```

**Option 3: Install globally (if no venv)**

```bash
pip3 install --user -r scripts/requirements.txt
```

**Required packages:**
- `httpx` - For Gemini API calls
- `openai` - For OpenAI API calls

**Note**: The app will automatically detect and use the virtual environment Python at `backend/python/venv/bin/python3` if it exists. Otherwise, it will fall back to system Python.

#### 2. Configure API Keys

Create a `.env` file in `backend/python/`:

```bash
cd backend/python
touch .env
```

Add your API keys:
```
GOOGLE_API_KEY=your_google_api_key_here
OPENAI_API_KEY=your_openai_api_key_here
```

**Note**: You need at least one API key to use the corresponding service.

#### 3. Verify Scripts Work

Test the scripts manually:

```bash
# Test Gemini script
echo '{"text":"Hello world","service":"gemini","voice":"Kore","language":"en-US","audio_format":"mp3"}' | python3 scripts/tts_gemini.py

# Test OpenAI script
echo '{"text":"Hello world","service":"openai","voice":"alloy","audio_format":"mp3"}' | python3 scripts/tts_openai.py
```

Both should output JSON with `audio_data` (base64) and `success: true`.

### Flutter Setup

```bash
flutter pub get
flutter run
```

---

## Architecture Overview

### Script-Based Architecture

The app has been refactored to call Python scripts directly from Flutter instead of requiring a running server. This eliminates the dependency on a separate backend process.

**Flow:**
```
Flutter App
    ↓
Platform Channel (macOS)
    ↓
Python Script (tts_gemini.py or tts_openai.py)
    ↓
TTS API (Gemini/OpenAI)
    ↓
Base64 Audio Data
    ↓
Flutter (saves to file)
    ↓
Audio Player (plays file)
```

### Key Components

- **Scripts**: `scripts/tts_gemini.py`, `scripts/tts_openai.py`
- **Platform Channel**: macOS `AppDelegate.swift` executes Python scripts
- **Flutter Service**: `SpeechSynthesisScriptService` calls platform channel
- **Repository**: Saves audio to file and returns file path

### Benefits

1. ✅ **No Server Required** - No need to run a separate backend process
2. ✅ **Simpler Deployment** - Everything in one app
3. ✅ **Faster Startup** - No server initialization
4. ✅ **Better Integration** - Direct communication via platform channels

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

- [ ] Python scripts set up
- [ ] Python dependencies installed (httpx, openai)
- [ ] API keys configured in `backend/python/.env`
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
- [ ] Script execution failure shows error
- [ ] Invalid service config shows error
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

**Test Python Scripts:**
```bash
# Test Gemini script
echo '{"text":"test","service":"gemini","voice":"Kore","language":"en-US","audio_format":"mp3"}' | python3 scripts/tts_gemini.py

# Test OpenAI script
echo '{"text":"test","service":"openai","voice":"alloy","audio_format":"mp3"}' | python3 scripts/tts_openai.py
```

**Sample Audio URL for Testing:**
- MP3: `https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3`

---

## Google Cloud Setup

The Gemini TTS service uses Google Cloud Text-to-Speech API, which requires OAuth2 authentication.

### Quick Setup (Recommended for Development)

```bash
gcloud auth application-default login
```

This command will:
1. Open a browser window for you to sign in with your Google account
2. Store credentials in `~/.config/gcloud/application_default_credentials.json`
3. Allow the app to automatically use these credentials

**Note:** Make sure you have the Google Cloud SDK installed. If not, install it from https://cloud.google.com/sdk/docs/install

### Service Account Setup (Recommended for Production)

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

4. **Place the Key File:**
   
   Place the downloaded JSON key file in one of these locations:
   - `backend/python/service-account-key.json`
   - `service-account-key.json` (project root)
   - `.gcloud/service-account-key.json` (project root)
   
   Or set the environment variable:
   ```bash
   export GOOGLE_APPLICATION_CREDENTIALS=/path/to/your/service-account-key.json
   ```

### Enable the Text-to-Speech API

1. Go to [Google Cloud Console APIs](https://console.cloud.google.com/apis/library/texttospeech.googleapis.com)
2. Select your project
3. Click "Enable"

### Troubleshooting

**Error: "Your default credentials were not found"**
- Run `gcloud auth application-default login`

**Error: "API keys are not supported"**
- Google Cloud TTS requires OAuth2, not API keys. Use one of the authentication methods above.

**Error: "The Text-to-Speech API has not been used"**
- Enable the Text-to-Speech API in Google Cloud Console.

**Error: "Permission denied"**
- Make sure your service account or user account has the "Cloud Text-to-Speech API User" role.

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

### Python Script Issues

**Error: `SCRIPT_NOT_FOUND`**
- Ensure scripts are in `scripts/` directory
- Check script permissions: `chmod +x scripts/*.py`
- Verify script path in logs

**Error: `GOOGLE_API_KEY` or `OPENAI_API_KEY` not found**
- Create `.env` file in `backend/python/`
- Add API keys to `.env`
- Or set environment variables:
  ```bash
  export GOOGLE_API_KEY=your_key
  export OPENAI_API_KEY=your_key
  ```

**Error: Python execution fails**
- Ensure Python 3 is installed: `python3 --version`
- Python should be at `/usr/bin/python3` (default on macOS)
- Or update `AppDelegate.swift` to use different Python path

**Error: `ModuleNotFoundError: No module named 'openai'`**
- Install dependencies in virtual environment:
  ```bash
  cd backend/python
  source venv/bin/activate
  pip install -r ../../scripts/requirements.txt
  ```
- Or install globally:
  ```bash
  pip3 install --user -r scripts/requirements.txt
  ```

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

