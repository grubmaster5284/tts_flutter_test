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

  // Register method channel handler
  function registerMethodChannel() {
    if (isRegistered) {
      return;
    }

    try {
      // Method 1: Register via Flutter's plugin system (if available)
      if (window._flutter && window._flutter.plugins) {
        if (window._flutter.plugins.registerMethodCallHandler) {
          window._flutter.plugins.registerMethodCallHandler(channelName, handleMethodCall);
          isRegistered = true;
          console.log('TTS Channel registered via plugin system');
          return;
        }
      }

      // Method 2: Intercept platform messages at the loader level
      if (window._flutter && window._flutter.loader) {
        const loader = window._flutter.loader;
        
        // Store original sendPlatformMessage if it exists
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
          console.log('TTS Channel registered via message interception');
          return;
        }
      }

      // Method 3: Register when engine is available
      if (window._flutter && window._flutter.loader && window._flutter.loader.engine) {
        const engine = window._flutter.loader.engine;
        if (engine.registerMethodCallHandler) {
          engine.registerMethodCallHandler(channelName, handleMethodCall);
          isRegistered = true;
          console.log('TTS Channel registered via engine');
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

  // Fallback: try periodically for a few seconds
  let attempts = 0;
  const maxAttempts = 20;
  const intervalId = setInterval(function() {
    attempts++;
    if (isRegistered || attempts >= maxAttempts) {
      clearInterval(intervalId);
      if (!isRegistered) {
        console.warn('TTS Channel: Failed to register after multiple attempts');
      }
    } else {
      registerMethodChannel();
    }
  }, 200);
})();

