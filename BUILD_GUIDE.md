# Build Guide for Multi-Platform Flutter App

This guide provides instructions for building the TTS Flutter Test app for iOS, Android, Linux, and Windows.

## Prerequisites

### General Requirements
- Flutter SDK (3.9.2 or higher)
- Dart SDK (included with Flutter)
- Git

### Platform-Specific Requirements

#### iOS
- macOS (required for iOS builds)
- Xcode (latest version recommended)
- CocoaPods (`sudo gem install cocoapods`)
- iOS Simulator or physical iOS device

#### Android
- Android Studio
- Android SDK (API level 21 or higher)
- Java Development Kit (JDK) 11 or higher
- Android emulator or physical Android device

#### Linux
- Linux operating system
- Required development libraries:
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
- Git for Windows

## Building the App

### 1. Verify Flutter Setup

First, ensure Flutter is properly configured:

```bash
flutter doctor
```

This should show checkmarks (✓) for all platforms you want to build for.

### 2. Get Dependencies

```bash
flutter pub get
```

### 3. Platform-Specific Build Instructions

#### Android

**Debug Build:**
```bash
flutter build apk --debug
```

**Release Build:**
```bash
flutter build apk --release
```

**App Bundle (for Play Store):**
```bash
flutter build appbundle --release
```

**Install on connected device:**
```bash
flutter install
```

**Run on emulator/device:**
```bash
flutter run
```

#### iOS

**Note:** iOS builds can only be done on macOS.

**Debug Build:**
```bash
flutter build ios --debug
```

**Release Build:**
```bash
flutter build ios --release
```

**Build for Simulator:**
```bash
flutter build ios --simulator
```

**Run on Simulator:**
```bash
flutter run -d ios
```

**Open in Xcode:**
```bash
open ios/Runner.xcworkspace
```

**Note:** For release builds, you'll need to configure code signing in Xcode.

#### Linux

**Debug Build:**
```bash
flutter build linux --debug
```

**Release Build:**
```bash
flutter build linux --release
```

**Run:**
```bash
flutter run -d linux
```

**Output Location:**
- Debug: `build/linux/x64/debug/bundle/`
- Release: `build/linux/x64/release/bundle/`

#### Windows

**Debug Build:**
```bash
flutter build windows --debug
```

**Release Build:**
```bash
flutter build windows --release
```

**Run:**
```bash
flutter run -d windows
```

**Output Location:**
- Debug: `build/windows/x64/runner/Debug/`
- Release: `build/windows/x64/runner/Release/`

## Quick Build Script

You can use the following commands to build for all platforms:

### Build All Platforms (from macOS)
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release

# Linux (if on Linux machine)
flutter build linux --release

# Windows (if on Windows machine)
flutter build windows --release
```

### Build All Platforms (from Linux)
```bash
# Android
flutter build apk --release

# Linux
flutter build linux --release
```

### Build All Platforms (from Windows)
```bash
# Android
flutter build apk --release

# Windows
flutter build windows --release
```

## Platform-Specific Notes

### Media Key Support
- **Desktop Platforms (macOS, Linux, Windows):** Media key detection is fully supported
- **Mobile Platforms (iOS, Android):** Media key detection is not available and will be gracefully skipped

### File Picker
- Works on all platforms
- Platform-specific file dialogs will be used automatically

### Audio Playback
- Uses `audioplayers` package which supports all platforms
- Audio formats supported: MP3, WAV, M4A, AAC, OGG, FLAC, WMA

## Troubleshooting

### Android Build Issues

**NDK (Native Development Kit) errors:**
If you see an error like `[CXX1101] NDK at ... did not have a source.properties file`:
```bash
# Remove the corrupted NDK (replace version number with your version)
rm -rf ~/Library/Android/sdk/ndk/27.0.12077973

# Clean Flutter build
flutter clean

# The NDK will be automatically re-downloaded on next build
flutter pub get
flutter run
```

**Gradle sync failed:**
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

**SDK not found:**
- Open Android Studio
- Go to Tools → SDK Manager
- Install required SDK platforms and build tools

**Build cache issues:**
```bash
# Clean everything
flutter clean
cd android
./gradlew clean
cd ..
rm -rf ~/.gradle/caches/
flutter pub get
```

### iOS Build Issues

**iOS runtime version mismatch:**
If you see an error like `iOS 26.1 is not installed` or `Unable to find a destination matching the provided destination specifier`:

**Option 1: Install the required iOS runtime**
1. Open Xcode
2. Go to **Xcode → Settings → Components** (or **Xcode → Preferences → Components** in older versions)
3. Download and install the required iOS runtime version
4. Wait for the download to complete
5. Try running again: `flutter run`

**Option 2: Use a different simulator**
```bash
# List available simulators
xcrun simctl list devices available

# List Flutter devices
flutter devices

# Run on a specific device
flutter run -d <device-id>

# Or use an iOS 18.6 simulator (if available)
flutter run -d <ios-18.6-device-id>
```

**Option 3: Boot a compatible simulator**
```bash
# Boot a specific simulator
xcrun simctl boot <device-id>

# Then run Flutter
flutter run
```

**Pod install failed:**
```bash
cd ios
pod deintegrate
pod install
cd ..
```

**Code signing issues:**
- Open `ios/Runner.xcworkspace` in Xcode
- Select Runner target → Signing & Capabilities
- Configure your development team

### Linux Build Issues

**Missing dependencies:**
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

**CMake errors:**
```bash
flutter clean
flutter pub get
flutter build linux --debug
```

### Windows Build Issues

**Visual Studio not found:**
- Install Visual Studio 2019 or higher
- Ensure "Desktop development with C++" workload is installed
- Install Windows 10/11 SDK

**Build errors:**
```bash
flutter clean
flutter pub get
flutter build windows --debug
```

## Testing Builds

### Android
```bash
# Install on connected device
flutter install

# Run tests
flutter test
```

### iOS
```bash
# Run on simulator
flutter run -d ios

# Run tests
flutter test
```

### Linux
```bash
# Run the app
flutter run -d linux

# Run tests
flutter test
```

### Windows
```bash
# Run the app
flutter run -d windows

# Run tests
flutter test
```

## Distribution

### Android
- **APK:** Use `build/app/outputs/flutter-apk/app-release.apk`
- **App Bundle:** Use `build/app/outputs/bundle/release/app-release.aab` (for Play Store)

### iOS
- Build in Xcode and use Archive for App Store distribution
- Or use `flutter build ipa` for ad-hoc distribution

### Linux
- Distribute the entire `bundle/` folder
- Or create a `.AppImage` or `.deb` package

### Windows
- Distribute the entire `Release/` folder
- Or create an installer using tools like Inno Setup or NSIS

## Continuous Integration

For CI/CD pipelines, you can use:

```yaml
# Example GitHub Actions workflow
- name: Build Android
  run: flutter build apk --release

- name: Build iOS
  run: flutter build ios --release
  # Note: Requires macOS runner

- name: Build Linux
  run: flutter build linux --release
  # Note: Requires Linux runner

- name: Build Windows
  run: flutter build windows --release
  # Note: Requires Windows runner
```

## Additional Resources

- [Flutter Build Documentation](https://docs.flutter.dev/deployment)
- [Platform-Specific Setup](https://docs.flutter.dev/get-started/install)
- [Flutter Release Checklist](https://docs.flutter.dev/deployment/android#reviewing-the-app-bundle)

