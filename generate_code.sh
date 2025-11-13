#!/bin/bash
# Script to generate Freezed code for audio playback feature

echo "Running flutter pub get..."
flutter pub get

echo "Generating Freezed code..."
flutter pub run build_runner build --delete-conflicting-outputs

echo "Done! Freezed code has been generated."

