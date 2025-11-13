#!/bin/bash

# Build script for TTS Flutter Test app
# This script builds the app for all supported platforms

set -e  # Exit on error

echo "🚀 Building TTS Flutter Test App for All Platforms"
echo "=================================================="

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    exit 1
fi

# Get dependencies
echo -e "\n${BLUE}📦 Getting dependencies...${NC}"
flutter pub get

# Check Flutter doctor
echo -e "\n${BLUE}🔍 Checking Flutter setup...${NC}"
flutter doctor

# Build for Android
echo -e "\n${GREEN}🤖 Building for Android...${NC}"
if flutter build apk --release; then
    echo -e "${GREEN}✅ Android build successful!${NC}"
    echo "   APK location: build/app/outputs/flutter-apk/app-release.apk"
else
    echo -e "${YELLOW}⚠️  Android build failed (this is okay if you don't have Android SDK)${NC}"
fi

# Build for iOS (macOS only)
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo -e "\n${GREEN}🍎 Building for iOS...${NC}"
    if flutter build ios --release --no-codesign; then
        echo -e "${GREEN}✅ iOS build successful!${NC}"
        echo "   Build location: build/ios/iphoneos/Runner.app"
    else
        echo -e "${YELLOW}⚠️  iOS build failed (check Xcode setup)${NC}"
    fi
else
    echo -e "\n${YELLOW}⚠️  Skipping iOS build (requires macOS)${NC}"
fi

# Build for Linux
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo -e "\n${GREEN}🐧 Building for Linux...${NC}"
    if flutter build linux --release; then
        echo -e "${GREEN}✅ Linux build successful!${NC}"
        echo "   Build location: build/linux/x64/release/bundle/"
    else
        echo -e "${YELLOW}⚠️  Linux build failed (check dependencies)${NC}"
    fi
else
    echo -e "\n${YELLOW}⚠️  Skipping Linux build (requires Linux OS)${NC}"
fi

# Build for Windows (if on Windows or using WSL)
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]] || command -v cmd.exe &> /dev/null; then
    echo -e "\n${GREEN}🪟 Building for Windows...${NC}"
    if flutter build windows --release; then
        echo -e "${GREEN}✅ Windows build successful!${NC}"
        echo "   Build location: build/windows/x64/runner/Release/"
    else
        echo -e "${YELLOW}⚠️  Windows build failed (check Visual Studio setup)${NC}"
    fi
else
    echo -e "\n${YELLOW}⚠️  Skipping Windows build (requires Windows OS)${NC}"
fi

echo -e "\n${GREEN}✨ Build process completed!${NC}"
echo -e "\n📝 Note: Some platforms may have failed if the required SDKs are not installed."
echo -e "   Check BUILD_GUIDE.md for platform-specific setup instructions."

