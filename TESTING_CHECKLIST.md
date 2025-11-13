# Quick Testing Checklist

## Pre-Testing Setup
- [ ] Backend server running on `http://localhost:8000`
- [ ] Flutter app launched and running
- [ ] Internet connection available (for remote audio URLs)

---

## Audio Playback Tests (11 tests)

### Basic Functionality
- [ ] **Test 1.1**: Load audio from URL
- [ ] **Test 1.1a**: Load audio from file picker
- [ ] **Test 1.2**: Quick load with example URLs
- [ ] **Test 1.3**: Play/Pause/Stop controls work
- [ ] **Test 1.4**: Progress bar seeking works
- [ ] **Test 1.5**: Volume control adjusts audio
- [ ] **Test 1.6**: Playback speed control works
- [ ] **Test 1.7**: Compact mode toggle works
- [ ] **Test 1.8**: Multiple audio sources handled correctly
- [ ] **Test 1.9**: Invalid URL shows error
- [ ] **Test 1.10**: Clear icon resets player
- [ ] **Test 1.11**: File picker filtering works correctly

---

## Speech Synthesis Tests (10 tests)

### Basic Functionality
- [ ] **Test 2.1**: Basic text-to-speech conversion works
- [ ] **Test 2.2**: Service selection (Gemini/OpenAI/Polly) works
- [ ] **Test 2.3**: Voice selection works
- [ ] **Test 2.4**: Language selection works
- [ ] **Test 2.5**: Audio format selection works
- [ ] **Test 2.6**: Empty text validation prevents submission
- [ ] **Test 2.7**: Long text (1000+ chars) handled correctly
- [ ] **Test 2.8**: Backend unavailable shows error
- [ ] **Test 2.9**: Invalid service config shows error
- [ ] **Test 2.10**: Generated audio plays in player (if integrated)

---

## Settings Tests (12 tests)

### TTS Settings
- [ ] **Test 3.1**: Default TTS Service saves and persists
- [ ] **Test 3.2**: Default Voice saves and persists
- [ ] **Test 3.3**: Default Language saves and persists
- [ ] **Test 3.4**: Default Audio Format saves and persists

### Playback Settings
- [ ] **Test 3.5**: Default Volume saves and persists
- [ ] **Test 3.6**: Default Playback Speed saves and persists

### Appearance
- [ ] **Test 3.7**: Theme Preference changes and persists

### General
- [ ] **Test 3.8**: Reset to Defaults works
- [ ] **Test 3.9**: Settings persist after app restart
- [ ] **Test 3.10**: Settings reload works
- [ ] **Test 3.11**: Loading state displays correctly
- [ ] **Test 3.12**: Error handling works

---

## Integration Tests (3 tests)

- [ ] **Test 4.1**: End-to-end speech synthesis flow works
- [ ] **Test 4.2**: Settings applied to Speech Synthesis page
- [ ] **Test 4.3**: Settings applied to Audio Player

---

## Error Handling Tests (4 tests)

- [ ] **Test 5.1**: Network connectivity issues handled
- [ ] **Test 5.2**: Invalid API responses handled
- [ ] **Test 5.3**: Audio playback errors handled
- [ ] **Test 5.4**: Concurrent operations handled

---

## Quick Test URLs

**Sample Audio URL for Testing:**
- MP3: `https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3`

**Backend Health Check:**
```bash
curl http://localhost:8000/api/v1/tts/synthesize \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"text":"test","service":"gemini","language":"en","audio_format":"mp3"}'
```

---

## Common Issues to Watch For

- [ ] Audio doesn't load (check URL validity)
- [ ] Playback doesn't start (check audio format support)
- [ ] Speech synthesis fails (check backend is running)
- [ ] Settings don't persist (check shared_preferences)
- [ ] Errors not displayed (check error handling UI)
- [ ] UI freezes during operations (check async handling)

---

## Notes

- Test on your target platform(s)
- Test with different network conditions
- Test with various audio formats
- Verify error messages are user-friendly
- Check that loading states are visible

