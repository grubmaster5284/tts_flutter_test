# Legacy Code Directory

This directory contains legacy Python backend code that has been isolated from the main application.

## Structure

- `backend/python/`: Old Python FastAPI server that handled TTS API calls
- `scripts/`: Old Python TTS scripts that were executed via platform channels

## Status

**This code is NOT used by the application anymore.**

The application has been migrated to a pure Dart/Flutter implementation that makes direct HTTP calls to TTS APIs (Google Cloud TTS, OpenAI TTS, etc.) without requiring Python.

## Why Preserved?

This code is preserved for:
- **Reference**: Understanding the previous architecture and API integration patterns
- **Rollback**: Easy rollback capability if the Dart implementation has issues
- **Documentation**: Historical record of the previous implementation

## Migration Details

The migration involved:
1. Moving Python backend code to `_legacy/backend/python/`
2. Moving Python scripts to `_legacy/scripts/`
3. Commenting out Python execution code in `macos/Runner/AppDelegate.swift` with `[LEGACY]` markers
4. Commenting out legacy Flutter services with `[LEGACY]` markers
5. Creating new pure Dart TTS services that make direct HTTP calls to TTS APIs

## Rollback Instructions

If you need to rollback to the Python implementation:

1. Move `_legacy/backend/python/` back to `backend/python/`
2. Move `_legacy/scripts/` back to `scripts/`
3. Uncomment the Python execution code in `macos/Runner/AppDelegate.swift`
4. Uncomment the legacy Flutter services
5. Update the repository to use the legacy services

## New Implementation

The new implementation uses:
- Pure Dart TTS services in `lib/speech_synthesis/data/sources/remote/`
- Direct HTTP calls to TTS APIs (no Python backend required)
- Service factory pattern for creating service instances
- All platforms use the same Dart services (no platform-specific code)

