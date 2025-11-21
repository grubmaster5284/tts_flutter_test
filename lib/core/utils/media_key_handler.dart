import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/services.dart';
import 'package:media_key_detector/media_key_detector.dart';
import 'package:tts_flutter_test/core/utils/logger.dart';

/// Singleton service for handling media key events from the keyboard
/// 
/// This service provides a centralized way to listen to media keys (play/pause, rewind,
/// fast forward, volume up/down) on desktop platforms (macOS, Windows, Linux).
/// It uses:
/// - media_key_detector package for play/pause/rewind/fast forward keys
/// - Platform channels for volume keys (which require native implementation)
/// 
/// This is a singleton pattern (accessed via MediaKeyHandler.instance) to ensure
/// only one instance manages media key listeners throughout the app lifecycle.
/// 
/// This service is part of the Core utilities layer and provides cross-cutting
/// functionality that can be used by any feature module.
class MediaKeyHandler {
  MediaKeyHandler._();
  
  static final MediaKeyHandler instance = MediaKeyHandler._();
  
  static const MethodChannel _volumeChannel = MethodChannel('com.tts_flutter_test/volume_keys');
  
  bool _isInitialized = false;
  Function(MediaKey)? _onMediaKeyPressed;
  Function(bool isVolumeUp)? _onVolumeKeyPressed;
  
  /// Check if running on a desktop platform that supports media keys
  bool _isDesktopPlatform() {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  /// Initialize the media key handler
  /// 
  /// [onMediaKeyPressed] - Callback for play/pause/next/previous media keys
  /// [onVolumeKeyPressed] - Callback for volume up/down keys (isVolumeUp: true for up, false for down)
  void initialize({
    Function(MediaKey)? onMediaKeyPressed,
    Function(bool isVolumeUp)? onVolumeKeyPressed,
  }) {
    if (!_isDesktopPlatform()) {
      AppLogger.info('MediaKeyHandler: Not supported on this platform', tag: 'MediaKeyHandler');
      return;
    }
    
    if (_isInitialized) {
      AppLogger.warning('MediaKeyHandler already initialized', tag: 'MediaKeyHandler');
      return;
    }
    
    _onMediaKeyPressed = onMediaKeyPressed;
    _onVolumeKeyPressed = onVolumeKeyPressed;
    
    try {
      // Listen to media key detector events
      mediaKeyDetector.addListener(_handleMediaKey);
      
      // Set up platform channel listener for volume keys
      _setupVolumeKeyListener();
      
      _isInitialized = true;
      AppLogger.info('MediaKeyHandler initialized', tag: 'MediaKeyHandler');
    } catch (e, stackTrace) {
      AppLogger.error('Failed to initialize MediaKeyHandler', 
          tag: 'MediaKeyHandler',
          error: e,
          stackTrace: stackTrace);
    }
  }
  
  /// Handle media key events from media_key_detector
  void _handleMediaKey(MediaKey mediaKey) {
    AppLogger.debug('Media key pressed', tag: 'MediaKeyHandler', data: {'key': mediaKey.toString()});
    
    if (_onMediaKeyPressed != null) {
      _onMediaKeyPressed!(mediaKey);
    }
  }
  
  /// Set up listener for volume keys using platform channel
  void _setupVolumeKeyListener() {
    _volumeChannel.setMethodCallHandler((call) async {
      if (call.method == 'volumeKeyPressed') {
        final isVolumeUp = call.arguments as bool? ?? false;
        AppLogger.debug('Volume key pressed via platform channel', 
            tag: 'MediaKeyHandler', 
            data: {'isVolumeUp': isVolumeUp});
        
        if (_onVolumeKeyPressed != null) {
          _onVolumeKeyPressed!(isVolumeUp);
        }
      }
    });
    
    // Request to start listening to volume keys on the platform side
    _volumeChannel.invokeMethod('startListening');
  }
  
  /// Dispose and clean up listeners
  void dispose() {
    if (!_isInitialized) return;
    
    mediaKeyDetector.removeListener(_handleMediaKey);
    _volumeChannel.invokeMethod('stopListening');
    _volumeChannel.setMethodCallHandler(null);
    
    _isInitialized = false;
    _onMediaKeyPressed = null;
    _onVolumeKeyPressed = null;
    
    AppLogger.info('MediaKeyHandler disposed', tag: 'MediaKeyHandler');
  }
}

