#!/bin/bash

# Flutter API Client - Quick Start Script
echo "======================================"
echo "Flutter API Client - Quick Start"
echo "======================================"
echo ""

# Check if Flutter is installed
if ! command -v flutter &> /dev/null
then
    echo "❌ Flutter is not installed. Please install Flutter first:"
    echo "   https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✓ Flutter found"
echo ""

# Check Flutter setup
echo "Checking Flutter setup..."
flutter doctor
echo ""

# Install dependencies
echo "Installing dependencies..."
flutter pub get

if [ $? -eq 0 ]; then
    echo "✓ Dependencies installed successfully"
else
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo ""
echo "======================================"
echo "Next Steps:"
echo "======================================"
echo ""
echo "1. Configure Firebase:"
echo "   - Install FlutterFire CLI: dart pub global activate flutterfire_cli"
echo "   - Run: flutterfire configure"
echo "   - Follow the prompts to set up your Firebase project"
echo ""
echo "2. For Android:"
echo "   - Get SHA-1: cd android && ./gradlew signingReport"
echo "   - Add SHA-1 to Firebase Console"
echo "   - Download google-services.json to android/app/"
echo ""
echo "3. For iOS:"
echo "   - Download GoogleService-Info.plist"
echo "   - Add to Xcode project (ios/Runner.xcworkspace)"
echo "   - Update Info.plist with REVERSED_CLIENT_ID"
echo ""
echo "4. Run the app:"
echo "   flutter run"
echo ""
echo "📚 For detailed setup instructions, see:"
echo "   - README.md"
echo "   - SETUP_GUIDE.md"
echo ""
echo "======================================"
