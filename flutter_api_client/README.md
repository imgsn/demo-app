# Flutter API Client

A beautiful and feature-rich Flutter application for testing RESTful APIs with Firebase authentication, request history, and dark mode support.

## Features

- **Google Firebase Authentication** - Secure sign-in with your Google account
- **RESTful API Testing** - Support for GET, POST, PUT, DELETE, and PATCH requests
- **Request Customization** - Add custom headers and request bodies
- **Response Viewer** - Beautiful formatted response display with syntax highlighting
- **Request History** - Save and manage all your API requests locally
- **Dark/Light Mode** - Comfortable viewing experience with theme toggle
- **Error Handling** - Comprehensive error messages and validation
- **Beautiful UI** - Modern Material Design 3 with smooth animations

## Screenshots

(Add your screenshots here after building the app)

## Prerequisites

Before you begin, ensure you have the following installed:
- Flutter SDK (3.0.0 or higher)
- Dart SDK
- Android Studio / Xcode (for mobile development)
- Firebase CLI
- A Firebase project

## Firebase Setup

### 1. Create a Firebase Project

1. Go to the [Firebase Console](https://console.firebase.google.com/)
2. Click "Add project" and follow the setup wizard
3. Enable Google Analytics (optional)

### 2. Enable Google Sign-In

1. In the Firebase Console, navigate to **Authentication** > **Sign-in method**
2. Enable **Google** as a sign-in provider
3. Add your support email

### 3. Configure Firebase for Your App

Install the FlutterFire CLI:
```bash
dart pub global activate flutterfire_cli
```

Navigate to your project directory:
```bash
cd flutter_api_client
```

Run the configuration command:
```bash
flutterfire configure
```

This will:
- Create/update `firebase_options.dart` with your project configuration
- Configure Android and iOS apps
- Download configuration files

### 4. Android Configuration

#### Add SHA-1 and SHA-256 fingerprints

Get your SHA keys:
```bash
cd android
./gradlew signingReport
```

Add these SHA keys to your Firebase project:
1. Go to Firebase Console > Project Settings > Your Apps
2. Select your Android app
3. Add SHA-1 and SHA-256 fingerprints

#### Update google-services.json

1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/google-services.json`

### 5. iOS Configuration

1. Download `GoogleService-Info.plist` from Firebase Console
2. Open `ios/Runner.xcworkspace` in Xcode
3. Drag `GoogleService-Info.plist` into the Runner folder
4. Update `ios/Runner/Info.plist` with the following:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <!-- Replace with your REVERSED_CLIENT_ID from GoogleService-Info.plist -->
            <string>com.googleusercontent.apps.YOUR_CLIENT_ID</string>
        </array>
    </dict>
</array>
```

## Installation

1. Clone or navigate to the project directory:
```bash
cd flutter_api_client
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run build_runner (if you modify the models):
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

4. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── firebase_options.dart     # Firebase configuration
├── models/                   # Data models
│   ├── api_request.dart
│   └── api_request.g.dart   # Generated Hive adapter
├── providers/               # State management
│   └── theme_provider.dart
├── screens/                 # App screens
│   ├── splash_screen.dart
│   ├── login_screen.dart
│   └── home_screen.dart
├── services/               # Business logic
│   ├── auth_service.dart
│   ├── api_service.dart
│   └── storage_service.dart
└── widgets/                # Reusable widgets
    ├── request_form.dart
    ├── request_history.dart
    └── response_viewer.dart
```

## Usage

### Making API Requests

1. **Sign in** with your Google account
2. **Select HTTP method** (GET, POST, PUT, DELETE, PATCH)
3. **Enter the URL** of the API endpoint
4. **Add headers** (optional) - Click "Headers" and add custom headers
5. **Add request body** (optional) - For POST/PUT/PATCH requests, add JSON body
6. **Click "Send Request"** to execute
7. **View the response** - Status code, headers, and response body

### Managing Request History

- All requests are automatically saved locally
- Access history from the **History** tab
- Click on any past request to load it
- Delete individual requests or clear all history

### Theme Toggle

- Click the theme icon in the app bar to switch between light and dark modes
- Your preference is saved locally

## Troubleshooting

### Firebase Authentication Issues

**Problem**: Google Sign-In not working on Android
**Solution**:
- Ensure SHA-1 and SHA-256 fingerprints are added to Firebase Console
- Check that `google-services.json` is in the correct location
- Verify package name matches in Firebase Console and `android/app/build.gradle`

**Problem**: "PlatformException" during sign-in
**Solution**:
- Run `flutter clean` and `flutter pub get`
- Rebuild the app

### Network Requests

**Problem**: HTTP requests failing
**Solution**:
- Ensure you have internet permission in AndroidManifest.xml (already added)
- Check the API endpoint URL is correct and accessible
- Verify headers and request body format

### Build Issues

**Problem**: Gradle build errors
**Solution**:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

**Problem**: iOS build errors
**Solution**:
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter run
```

## Dependencies

- `firebase_core` - Firebase initialization
- `firebase_auth` - Firebase authentication
- `google_sign_in` - Google Sign-In
- `http` - HTTP requests
- `hive` & `hive_flutter` - Local storage
- `provider` - State management
- `shared_preferences` - Simple key-value storage
- `uuid` - Generate unique IDs
- `intl` - Internationalization and date formatting

## Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

## Contributing

Feel free to submit issues and enhancement requests!

## License

This project is open source and available under the MIT License.

## Support

For issues related to:
- **Flutter**: [Flutter Documentation](https://docs.flutter.dev/)
- **Firebase**: [Firebase Documentation](https://firebase.google.com/docs)
- **This App**: Create an issue in the repository

## Features Roadmap

- [ ] Export request history
- [ ] Request collections/folders
- [ ] Environment variables
- [ ] Response syntax highlighting
- [ ] GraphQL support
- [ ] WebSocket testing
- [ ] Share requests with team

---

Made with ❤️ using Flutter
