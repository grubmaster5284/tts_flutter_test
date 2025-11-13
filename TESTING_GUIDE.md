# Testing Guide for TTS Flutter App

This guide provides step-by-step instructions to test all functionalities in your TTS Flutter application.

## Prerequisites

1. **Backend Server**: Ensure your Python backend server is running on `http://localhost:8000`
   - If not running, start it from the `backend/python` directory
   - The server should be accessible at `http://localhost:8000/api/v1/tts/synthesize`

2. **Flutter App**: Run the Flutter app on your preferred platform (iOS, Android, macOS, Web, etc.)

---

## Table of Contents

1. [Audio Playback Feature Testing](#1-audio-playback-feature-testing)
2. [Speech Synthesis Feature Testing](#2-speech-synthesis-feature-testing)
3. [Settings Feature Testing](#3-settings-feature-testing)
4. [Integration Testing](#4-integration-testing)
5. [Error Handling Testing](#5-error-handling-testing)

---

## 1. Audio Playback Feature Testing

### Test 1.1: Basic Audio Loading from URL
**Steps:**
1. Launch the app (you should see the "Audio Player Test" page)
2. In the "Load Audio" section, enter a valid audio URL:
   - Example: `https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3`
3. Click the "Load Audio" button
4. **Expected Result**: 
   - Audio should load successfully
   - Progress bar should appear
   - Time display should show "00:00 / [duration]"
   - Play button should become enabled

### Test 1.1a: Basic Audio Loading from File Picker
**Steps:**
1. Launch the app
2. In the "Load Audio" section, click the folder icon (📁) in the text field
3. **Expected Result**: 
   - File picker dialog should open (Finder on macOS)
   - Only audio files should be visible/filtered (mp3, wav, m4a, aac, ogg, flac, etc.)
4. Select an audio file from your system
5. **Expected Result**: 
   - File path should populate in the text field
   - Audio should automatically load (or click "Load Audio" button)
   - Audio should load successfully with duration displayed

### Test 1.2: Quick Load with Example URL
**Steps:**
1. Click the "Sample MP3" button
2. **Expected Result**: 
   - URL should populate in the text field
   - Audio should load automatically
   - Player controls should become active
   - Duration should be displayed once loaded

### Test 1.3: Playback Controls
**Steps:**
1. Load an audio file (use Test 1.1 or 1.2)
2. Click the **Play** button (▶️)
3. **Expected Result**: 
   - Audio should start playing
   - Play button should change to Pause button (⏸️)
   - Progress bar should move forward
   - Time display should update in real-time
4. Click the **Pause** button (⏸️)
5. **Expected Result**: 
   - Audio should pause
   - Pause button should change back to Play button
   - Progress bar should stop moving
6. Click **Play** again
7. **Expected Result**: Audio should resume from where it paused
8. Click the **Stop** button (⏹️)
9. **Expected Result**: 
   - Audio should stop completely
   - Progress should reset to 00:00
   - Play button should be available again

### Test 1.4: Progress Bar Seeking
**Steps:**
1. Load and play an audio file
2. Wait for audio to play for a few seconds
3. Click/drag on the progress bar to a different position (e.g., 50% through the track)
4. **Expected Result**: 
   - Audio should jump to the new position
   - Time display should update to reflect the new position
   - Playback should continue from the new position

### Test 1.5: Volume Control
**Steps:**
1. Load and play an audio file
2. Locate the volume control slider
3. Drag the volume slider to different values:
   - 0% (muted)
   - 50%
   - 100% (maximum)
4. **Expected Result**: 
   - Audio volume should change in real-time
   - Volume percentage should be displayed
   - At 0%, audio should be muted but still playing

### Test 1.6: Playback Speed Control
**Steps:**
1. Load and play an audio file
2. Locate the playback speed control slider
3. Adjust the speed to different values:
   - 0.5x (slow)
   - 1.0x (normal)
   - 1.5x (fast)
   - 2.0x (very fast)
4. **Expected Result**: 
   - Audio playback speed should change immediately
   - Speed value should be displayed (e.g., "1.5x")
   - Audio pitch should remain normal (if supported)

### Test 1.7: Compact Mode
**Steps:**
1. Click the expand/compress icon in the app bar (top right)
2. **Expected Result**: 
   - Player should switch to compact mode
   - Only essential controls should be visible (play/pause, progress, time)
   - Volume and speed controls should be hidden
3. Toggle back to full mode
4. **Expected Result**: All controls should be visible again

### Test 1.8: Multiple Audio Sources
**Steps:**
1. Load one audio file (e.g., Sample MP3)
2. Play it for a few seconds
3. Load a different audio file (e.g., Sample WAV) without stopping
4. **Expected Result**: 
   - Previous audio should stop
   - New audio should load and be ready to play
   - Progress should reset to 00:00

### Test 1.9: Error Handling - Invalid URL
**Steps:**
1. Enter an invalid URL (e.g., `https://invalid-url-that-does-not-exist.com/audio.mp3`)
2. Click "Load Audio"
3. **Expected Result**: 
   - Error message should appear
   - Error should be displayed in a red error container
   - Player controls should remain disabled

### Test 1.10: Clear Functionality
**Steps:**
1. Load an audio file
2. Click the clear icon (X) in the text field
3. **Expected Result**: 
   - Audio source should be cleared
   - Text field should be empty
   - Player should reset to initial state

### Test 1.11: File Picker Filtering
**Steps:**
1. Click the folder icon (📁) to open file picker
2. Try to navigate and select files
3. **Expected Result**: 
   - File picker should only show audio file types
   - Supported formats: mp3, wav, m4a, aac, ogg, flac, wma, mp4, m4v, mov
   - Non-audio files should be filtered out or not selectable

---

## 2. Speech Synthesis Feature Testing

**Note**: To access the Speech Synthesis page, you may need to add navigation. For now, you can test by temporarily changing `main.dart` to show `SpeechSynthesisPage()`.

### Test 2.1: Basic Text-to-Speech Conversion
**Prerequisites**: Backend server must be running
**Steps:**
1. Navigate to the Speech Synthesis page
2. Enter text in the text input field (e.g., "Hello, this is a test")
3. Select a TTS Service (Gemini, OpenAI, or Polly)
4. Select a Voice (if available)
5. Select a Language (e.g., "en" for English)
6. Select an Audio Format (e.g., "mp3")
7. Click the "Synthesize Speech" button
8. **Expected Result**: 
   - Loading indicator should appear
   - After processing, success message should appear
   - Audio format and duration should be displayed
   - Generated audio should be available for playback

### Test 2.2: Service Selection
**Steps:**
1. On the Speech Synthesis page, open the "TTS Service" dropdown
2. Select each service option:
   - Gemini
   - OpenAI
   - Polly
3. **Expected Result**: 
   - Selected service should be saved
   - Service selection should persist when switching

### Test 2.3: Voice Selection
**Steps:**
1. Select a TTS Service
2. Open the Voice selector dropdown
3. Select different voices (if available for the selected service)
4. **Expected Result**: 
   - Voice selection should update
   - Different voices should be available based on the selected service

### Test 2.4: Language Selection
**Steps:**
1. Open the Language selector dropdown
2. Select different languages (e.g., "en", "es", "fr", "de")
3. **Expected Result**: 
   - Language selection should update
   - Language code should be displayed

### Test 2.5: Audio Format Selection
**Steps:**
1. Open the Audio Format dropdown
2. Select different formats:
   - MP3
   - WAV
   - OGG
   - AAC
   - FLAC
3. **Expected Result**: 
   - Format selection should update
   - Selected format should be used for synthesis

### Test 2.6: Empty Text Validation
**Steps:**
1. Leave the text input field empty
2. Try to click "Synthesize Speech"
3. **Expected Result**: 
   - Button should be disabled
   - No API call should be made

### Test 2.7: Long Text Input
**Steps:**
1. Enter a long text (1000+ characters)
2. Click "Synthesize Speech"
3. **Expected Result**: 
   - Should handle long text appropriately
   - Loading time may be longer
   - Success message should appear after completion

### Test 2.8: Error Handling - Backend Unavailable
**Steps:**
1. Stop the backend server
2. Enter text and click "Synthesize Speech"
3. **Expected Result**: 
   - Error message should appear
   - Error should indicate connection failure
   - Error card should be displayed with details

### Test 2.9: Error Handling - Invalid Service Configuration
**Steps:**
1. Select a service that may not be properly configured (e.g., OpenAI without API key)
2. Enter text and synthesize
3. **Expected Result**: 
   - Appropriate error message should appear
   - Error should indicate authentication or configuration issue

### Test 2.10: Integration with Audio Player
**Steps:**
1. Synthesize speech successfully
2. If audio player is integrated, verify the generated audio can be played
3. **Expected Result**: 
   - Generated audio should be playable
   - Audio player should load the synthesized audio
   - Playback controls should work

---

## 3. Settings Feature Testing

**Note**: To access the Settings page, you may need to add navigation. For now, you can test by temporarily changing `main.dart` to show `SettingsPage()`.

### Test 3.1: Default TTS Service Setting
**Steps:**
1. Navigate to the Settings page
2. In the "TTS Settings" section, find "Default TTS Service"
3. Change the dropdown to a different service (e.g., from "gemini" to "openai")
4. **Expected Result**: 
   - Setting should save automatically (or after explicit save)
   - Setting should persist after app restart

### Test 3.2: Default Voice Setting
**Steps:**
1. In Settings, find "Default Voice" text field
2. Enter a voice identifier (e.g., "en-US-Standard-A")
3. **Expected Result**: 
   - Value should save
   - Should be used as default in Speech Synthesis page

### Test 3.3: Default Language Setting
**Steps:**
1. In Settings, find "Default Language" text field
2. Enter a language code (e.g., "es" for Spanish)
3. **Expected Result**: 
   - Value should save
   - Should be used as default in Speech Synthesis page

### Test 3.4: Default Audio Format Setting
**Steps:**
1. In Settings, find "Default Audio Format" dropdown
2. Select a different format (e.g., "wav")
3. **Expected Result**: 
   - Setting should save
   - Should be used as default in Speech Synthesis page

### Test 3.5: Default Volume Setting
**Steps:**
1. In Settings, find "Default Volume" slider in "Playback Settings"
2. Adjust the slider to different values (0% to 100%)
3. **Expected Result**: 
   - Volume percentage should display in real-time
   - Setting should save
   - Should be applied when audio player loads

### Test 3.6: Default Playback Speed Setting
**Steps:**
1. In Settings, find "Default Playback Speed" slider
2. Adjust the slider to different values (0.5x to 2.0x)
3. **Expected Result**: 
   - Speed value should display (e.g., "1.5x")
   - Setting should save
   - Should be applied when audio player loads

### Test 3.7: Theme Preference Setting
**Steps:**
1. In Settings, find "Theme Preference" dropdown in "Appearance"
2. Select different options:
   - Light
   - Dark
   - System
3. **Expected Result**: 
   - Theme should change immediately (if implemented)
   - Setting should persist after app restart

### Test 3.8: Reset to Defaults
**Steps:**
1. Change several settings to non-default values
2. Click the "Reset to Defaults" button
3. **Expected Result**: 
   - All settings should revert to default values
   - Confirmation may appear (if implemented)

### Test 3.9: Settings Persistence
**Steps:**
1. Change multiple settings
2. Close the app completely
3. Reopen the app
4. Navigate back to Settings
5. **Expected Result**: 
   - All changed settings should be preserved
   - Settings should load correctly

### Test 3.10: Settings Reload
**Steps:**
1. On the Settings page, click the refresh icon in the app bar
2. **Expected Result**: 
   - Settings should reload from storage
   - Any unsaved changes may be lost (if applicable)

### Test 3.11: Settings Loading State
**Steps:**
1. Navigate to Settings page
2. Observe the initial load
3. **Expected Result**: 
   - Loading indicator should appear while settings load
   - Settings should appear after loading completes

### Test 3.12: Settings Error Handling
**Steps:**
1. If possible, corrupt settings storage (advanced)
2. Navigate to Settings page
3. **Expected Result**: 
   - Error message should appear
   - Retry button should be available
   - App should not crash

---

## 4. Integration Testing

### Test 4.1: End-to-End Speech Synthesis Flow
**Steps:**
1. Navigate to Speech Synthesis page
2. Configure all settings (service, voice, language, format)
3. Enter text and synthesize
4. Verify audio is generated successfully
5. If integrated, verify audio automatically loads in audio player
6. Play the generated audio
7. **Expected Result**: 
   - Complete flow should work without errors
   - Audio should play correctly

### Test 4.2: Settings Applied to Speech Synthesis
**Steps:**
1. Go to Settings and set default values:
   - Default TTS Service: OpenAI
   - Default Language: es
   - Default Audio Format: wav
2. Navigate to Speech Synthesis page
3. **Expected Result**: 
   - Default values should be pre-populated
   - User can still override them

### Test 4.3: Settings Applied to Audio Player
**Steps:**
1. Go to Settings and set:
   - Default Volume: 75%
   - Default Playback Speed: 1.5x
2. Navigate to Audio Player page
3. Load an audio file
4. **Expected Result**: 
   - Volume should be set to 75%
   - Playback speed should be set to 1.5x

---

## 5. Error Handling Testing

### Test 5.1: Network Connectivity Issues
**Steps:**
1. Disconnect from the internet
2. Try to synthesize speech
3. **Expected Result**: 
   - Appropriate network error should be displayed
   - Error message should be user-friendly

### Test 5.2: Invalid API Responses
**Steps:**
1. If possible, mock backend to return invalid responses
2. Try to synthesize speech
3. **Expected Result**: 
   - Error should be caught and displayed
   - App should not crash

### Test 5.3: Audio Playback Errors
**Steps:**
1. Try to load an unsupported audio format
2. **Expected Result**: 
   - Error should be displayed
   - User should be informed about the issue

### Test 5.4: Concurrent Operations
**Steps:**
1. Start a speech synthesis
2. While it's loading, try to start another one
3. **Expected Result**: 
   - Previous operation should be cancelled or queued
   - No conflicts should occur

---

## Testing Checklist

Use this checklist to ensure you've tested all major functionalities:

### Audio Playback
- [ ] Load audio from URL
- [ ] Play/Pause/Stop controls
- [ ] Progress bar seeking
- [ ] Volume control
- [ ] Playback speed control
- [ ] Compact mode toggle
- [ ] Error handling for invalid URLs
- [ ] Multiple audio sources

### Speech Synthesis
- [ ] Text input validation
- [ ] Service selection
- [ ] Voice selection
- [ ] Language selection
- [ ] Audio format selection
- [ ] Successful synthesis
- [ ] Error handling (backend unavailable)
- [ ] Error handling (invalid configuration)
- [ ] Long text handling

### Settings
- [ ] Default TTS Service
- [ ] Default Voice
- [ ] Default Language
- [ ] Default Audio Format
- [ ] Default Volume
- [ ] Default Playback Speed
- [ ] Theme Preference
- [ ] Reset to Defaults
- [ ] Settings persistence
- [ ] Settings reload

### Integration
- [ ] End-to-end speech synthesis flow
- [ ] Settings applied to Speech Synthesis
- [ ] Settings applied to Audio Player

### Error Handling
- [ ] Network errors
- [ ] Invalid API responses
- [ ] Audio playback errors
- [ ] Concurrent operations

---

## Notes

1. **Backend Dependency**: Most Speech Synthesis tests require the Python backend to be running. Ensure it's started before testing.

2. **Navigation**: Currently, the app shows only the Audio Player test page. To test Speech Synthesis and Settings, you may need to:
   - Temporarily modify `main.dart` to show different pages
   - Or add navigation (e.g., bottom navigation bar or drawer)

3. **Platform-Specific Testing**: Test on your target platforms (iOS, Android, macOS, Web) as audio playback behavior may vary.

4. **Performance**: Pay attention to:
   - Loading times for audio files
   - Speech synthesis response times
   - UI responsiveness during operations

5. **Accessibility**: Consider testing with:
   - Screen readers
   - Keyboard navigation (if applicable)
   - Different screen sizes

---

## Quick Test Commands

If you want to quickly verify the backend is running:
```bash
curl http://localhost:8000/api/v1/tts/synthesize \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"text":"test","service":"gemini","language":"en","audio_format":"mp3"}'
```

---

## Reporting Issues

When reporting issues, include:
1. Test case number and name
2. Steps to reproduce
3. Expected vs. actual result
4. Platform/device information
5. Error messages (if any)
6. Screenshots (if applicable)

