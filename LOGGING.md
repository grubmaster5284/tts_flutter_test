# Logging Guide

This project uses the `logger` package for comprehensive logging throughout the application.

## Quick Start

Import the logger:
```dart
import 'package:tts_flutter_test/core/utils/logger.dart';
```

Use it anywhere:
```dart
AppLogger.info('This is an info message');
AppLogger.error('This is an error', error: e, stackTrace: stackTrace);
AppLogger.debug('Debug information', data: someData);
```

## Log Levels

The logger supports different log levels:

- **`debug`** - Detailed information for development
- **`info`** - Informational messages about app progress
- **`warning`** - Potentially harmful situations
- **`error`** - Error events that might allow the app to continue
- **`fatal`** - Very severe errors that might cause the app to abort
- **`verbose`** - Very detailed information, typically for diagnostics

## Usage Examples

### Basic Logging
```dart
AppLogger.info('User logged in', tag: 'Auth');
AppLogger.debug('Processing request', tag: 'API');
AppLogger.warning('Low memory detected', tag: 'System');
```

### Error Logging with Stack Trace
```dart
try {
  // some code
} catch (e, stackTrace) {
  AppLogger.error('Failed to load data', 
      tag: 'DataLoader',
      error: e,
      stackTrace: stackTrace);
}
```

### Logging with Data
```dart
AppLogger.debug('Audio loaded', 
    tag: 'AudioPlayer', 
    data: {
      'source': audioSource,
      'duration': duration,
      'format': format,
    });
```

## Tags

Tags help organize logs by feature or component:
- `AudioPlayer` - Audio playback related logs
- `FilePicker` - File picker operations
- `App` - General app lifecycle
- `API` - Network requests
- `Auth` - Authentication
- etc.

## Log Output

Logs are displayed in the console with:
- **Emojis** for quick visual identification
- **Timestamps** for each log entry
- **Color coding** for different log levels
- **Stack traces** for errors
- **Method call information** (for errors)

Example output:
```
💡 [AudioPlayer] 2024-01-15 10:30:45.123 Loading audio
   └─ source: https://example.com/audio.mp3
   
❌ [AudioPlayer] 2024-01-15 10:30:45.456 Failed to load audio
   └─ Error: NetworkException
   └─ StackTrace:
      #0 AudioPlayer.loadAudio (audio_player.dart:123)
      #1 AudioPlayer.play (audio_player.dart:456)
```

## Configuring Log Level

The log level is set in `lib/core/utils/logger.dart`:

```dart
static Level _getLogLevel() {
  // In debug mode, show all logs
  return Level.debug;
  
  // In production, only show warnings and errors
  // return Level.warning;
}
```

## Viewing Logs

### In Development
- Logs appear in the Flutter console/terminal
- Use `flutter run` to see logs in real-time
- Use `flutter logs` to view logs from a running app

### Filtering Logs
You can filter logs by tag or level:
```bash
# Filter by tag
flutter logs | grep "AudioPlayer"

# Filter by level (errors only)
flutter logs | grep "ERROR"
```

## Best Practices

1. **Use appropriate log levels**
   - `debug` for development details
   - `info` for important events
   - `warning` for potential issues
   - `error` for actual errors

2. **Always include tags**
   - Makes it easier to filter and find relevant logs
   - Helps identify which component is logging

3. **Include context in error logs**
   - Always include `error` and `stackTrace` for exceptions
   - Add relevant data that helps debug the issue

4. **Don't log sensitive information**
   - Never log passwords, API keys, or personal data
   - Be careful with user data

5. **Use verbose logging sparingly**
   - Only for very detailed diagnostics
   - Can be noisy in production

## Common Logging Scenarios

### Audio Player Operations
```dart
AppLogger.info('Loading audio', tag: 'AudioPlayer', data: {'source': url});
AppLogger.debug('Player state changed', tag: 'AudioPlayer', data: {'state': state});
AppLogger.error('Failed to play', tag: 'AudioPlayer', error: e, stackTrace: st);
```

### File Operations
```dart
AppLogger.info('Opening file picker', tag: 'FilePicker');
AppLogger.info('File selected', tag: 'FilePicker', data: {'path': path});
AppLogger.error('Error picking file', tag: 'FilePicker', error: e, stackTrace: st);
```

### API Calls
```dart
AppLogger.debug('Making API request', tag: 'API', data: {'endpoint': endpoint});
AppLogger.info('API request successful', tag: 'API', data: {'statusCode': 200});
AppLogger.error('API request failed', tag: 'API', error: e, stackTrace: st);
```

## Troubleshooting

If you're not seeing logs:
1. Check that the log level is set appropriately
2. Verify you're using the correct log level method
3. Make sure the app is running in debug mode (logs are more verbose)
4. Check the console/terminal output

For production builds, consider:
- Setting log level to `Level.warning` or `Level.error`
- Implementing log file writing
- Using a remote logging service

