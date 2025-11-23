// [LEGACY] Old TTS platform channel handler - commented out for rollback
// This channel handler was used for Python script execution via platform channels.
// The app now uses pure Dart TTS services that make direct HTTP calls to TTS APIs.
// To rollback: uncomment the code below
/*
// Method channel handler for TTS script service on web
// This registers the platform channel handler for com.tts_flutter_test/tts_script

(function() {
  'use strict';

  const channelName = 'com.tts_flutter_test/tts_script';
  let isRegistered = false;

  // Handle method calls
  function handleMethodCall(method, args) {
    console.log('TTS Channel: Received method call:', method, args);
    
    return new Promise(function(resolve, reject) {
      if (method === 'synthesizeSpeech') {
        // Web cannot execute Python scripts directly
        // Return an error indicating this limitation
        reject({
          code: 'PLATFORM_NOT_SUPPORTED',
          message: 'Python script execution is not supported on web. Please use the remote API service instead.',
          details: null
        });
      } else {
        console.log('TTS Channel: Unknown method:', method);
        reject({
          code: 'METHOD_NOT_IMPLEMENTED',
          message: 'Method not implemented: ' + method,
          details: null
        });
      }
    });
  }

  // Register method channel handler using Flutter web's proper API
  function registerMethodChannel() {
    if (isRegistered) {
      return;
    }

    try {
      // Wait for Flutter web engine to be available
      // The engine is available via window._flutter.loader.engine after initialization
      if (window._flutter && window._flutter.loader) {
        const loader = window._flutter.loader;
        
        // Method 1: Register via engine's method channel API (preferred)
        if (loader.engine && loader.engine.registerMethodCallHandler) {
          loader.engine.registerMethodCallHandler(channelName, handleMethodCall);
          isRegistered = true;
          console.log('TTS Channel registered via engine API');
          return;
        }
        
        // Method 2: Register when engine becomes available via promise
        if (loader.loadEntrypoint && typeof loader.loadEntrypoint === 'function') {
          // Engine might not be ready yet, wait for it
          const checkEngine = function() {
            if (loader.engine && loader.engine.registerMethodCallHandler) {
              loader.engine.registerMethodCallHandler(channelName, handleMethodCall);
              isRegistered = true;
              console.log('TTS Channel registered via engine API (delayed)');
              return true;
            }
            return false;
          };
          
          if (checkEngine()) {
            return;
          }
        }
        
        // Method 3: Intercept platform messages at the loader level (fallback)
        // This is a workaround if the engine API is not available
        if (loader.sendPlatformMessage && !loader._originalSendPlatformMessage) {
          loader._originalSendPlatformMessage = loader.sendPlatformMessage;
          
          loader.sendPlatformMessage = function(channel, method, args) {
            if (channel === channelName) {
              return handleMethodCall(method, args);
            }
            // Call original handler for other channels
            if (this._originalSendPlatformMessage) {
              return this._originalSendPlatformMessage.call(this, channel, method, args);
            }
            return Promise.reject({
              code: 'CHANNEL_NOT_FOUND',
              message: 'Channel not found: ' + channel
            });
          };
          
          isRegistered = true;
          console.log('TTS Channel registered via message interception (fallback)');
          return;
        }
      }

      // Method 4: Try to register via ui_web if available
      if (window._flutter && window._flutter.ui_web) {
        const uiWeb = window._flutter.ui_web;
        if (uiWeb.platformViewRegistry && uiWeb.platformViewRegistry.registerMethodCallHandler) {
          uiWeb.platformViewRegistry.registerMethodCallHandler(channelName, handleMethodCall);
          isRegistered = true;
          console.log('TTS Channel registered via ui_web');
          return;
        }
      }

    } catch (e) {
      console.warn('Error registering TTS channel:', e);
    }

    // If not registered yet, retry
    if (!isRegistered) {
      setTimeout(registerMethodChannel, 200);
    }
  }

  // Start registration when Flutter is ready
  function init() {
    if (typeof window._flutter !== 'undefined') {
      registerMethodChannel();
    } else {
      // Wait for Flutter to load
      if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', function() {
          setTimeout(init, 100);
        });
      } else {
        setTimeout(init, 100);
      }
    }
  }

  // Multiple initialization strategies
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }

  // Also try after Flutter bootstrap loads
  window.addEventListener('flutter-initialized', function() {
    registerMethodChannel();
  });

  // Listen for engine ready event
  window.addEventListener('flutter-engine-ready', function() {
    registerMethodChannel();
  });

  // Fallback: try periodically for a few seconds
  let attempts = 0;
  const maxAttempts = 30; // Increased attempts
  const intervalId = setInterval(function() {
    attempts++;
    if (isRegistered || attempts >= maxAttempts) {
      clearInterval(intervalId);
      if (!isRegistered) {
        // This is not necessarily an error - the channel might not be needed if using remote API
        console.info('TTS Channel: Not registered (this is OK if using remote API service)');
      }
    } else {
      registerMethodChannel();
    }
  }, 200);
})();
*/

// [NEW] No platform-specific TTS code needed
// The app now uses pure Dart TTS services that work on all platforms
// All TTS operations are handled in Dart code via direct HTTP calls to TTS APIs
// This file can be removed or kept for reference

