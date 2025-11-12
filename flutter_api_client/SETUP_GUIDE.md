# Quick Setup Guide for Flutter API Client

## Step-by-Step Firebase Configuration

### 1. Install Flutter and Dependencies

```bash
# Verify Flutter installation
flutter doctor

# Navigate to project
cd flutter_api_client

# Install dependencies
flutter pub get
```

### 2. Install FlutterFire CLI

```bash
# Install FlutterFire CLI globally
dart pub global activate flutterfire_cli

# Verify installation
flutterfire --version
```

### 3. Create Firebase Project

1. Go to https://console.firebase.google.com/
2. Click **"Add project"**
3. Enter project name (e.g., "flutter-api-client")
4. Disable Google Analytics (optional) or configure it
5. Click **"Create project"**

### 4. Enable Authentication

1. In Firebase Console, click **"Authentication"** in the left sidebar
2. Click **"Get started"**
3. Go to **"Sign-in method"** tab
4. Click on **"Google"**
5. Toggle **"Enable"**
6. Select a support email
7. Click **"Save"**

### 5. Configure FlutterFire

Run this command in your project directory:

```bash
flutterfire configure
```

Follow the prompts:
- Select your Firebase project
- Select platforms (Android, iOS, Web)
- This will automatically create/update `lib/firebase_options.dart`

### 6. Android-Specific Setup

#### 6.1 Get SHA-1 and SHA-256 Keys

```bash
cd android
./gradlew signingReport
```

Copy the SHA-1 and SHA-256 keys from the output (look for the "debug" variant).

#### 6.2 Add SHA Keys to Firebase

1. In Firebase Console, go to **Project Settings** (gear icon)
2. Scroll down to **"Your apps"**
3. Click on your Android app
4. Click **"Add fingerprint"**
5. Paste SHA-1 key, click **"Save"**
6. Repeat for SHA-256 key

#### 6.3 Download google-services.json

1. In the same page, click **"Download google-services.json"**
2. Place the file in `android/app/google-services.json`

### 7. iOS-Specific Setup

#### 7.1 Download GoogleService-Info.plist

1. In Firebase Console > Project Settings
2. Under "Your apps", select your iOS app
3. Click **"Download GoogleService-Info.plist"**

#### 7.2 Add to Xcode

```bash
# Open Xcode workspace
cd ios
open Runner.xcworkspace
```

1. In Xcode, right-click on **"Runner"** folder (the yellow one)
2. Select **"Add Files to Runner"**
3. Select the downloaded `GoogleService-Info.plist`
4. Make sure **"Copy items if needed"** is checked
5. Click **"Add"**

#### 7.3 Update Info.plist

1. Open `GoogleService-Info.plist` and find `REVERSED_CLIENT_ID`
2. Copy its value
3. Open `ios/Runner/Info.plist`
4. Find the line with `YOUR_CLIENT_ID_HERE` and replace it with the copied value

### 8. Run the App

```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Run on connected device or emulator
flutter run
```

## Verification Checklist

- [ ] Flutter doctor shows no critical issues
- [ ] Firebase project created
- [ ] Google Sign-In enabled in Firebase Console
- [ ] `flutterfire configure` completed successfully
- [ ] `lib/firebase_options.dart` exists and has your project details
- [ ] Android: `google-services.json` placed in `android/app/`
- [ ] Android: SHA-1 and SHA-256 added to Firebase Console
- [ ] iOS: `GoogleService-Info.plist` added to Xcode project
- [ ] iOS: REVERSED_CLIENT_ID updated in Info.plist
- [ ] App builds and runs without errors
- [ ] Google Sign-In works on the login screen

## Common Issues and Solutions

### Issue: Google Sign-In fails on Android

**Solution:**
1. Verify SHA-1 fingerprint is added to Firebase Console
2. Check package name matches in:
   - `android/app/build.gradle` (applicationId)
   - Firebase Console (Android app package name)
3. Ensure `google-services.json` is in `android/app/`

### Issue: Build fails with "google-services.json not found"

**Solution:**
1. Download `google-services.json` from Firebase Console
2. Place it exactly in `android/app/google-services.json`
3. Run `flutter clean` and rebuild

### Issue: iOS Sign-In fails

**Solution:**
1. Verify `GoogleService-Info.plist` is added to Xcode project
2. Check REVERSED_CLIENT_ID is correctly added to Info.plist
3. Ensure bundle identifier matches in:
   - Xcode project settings
   - Firebase Console iOS app
4. Run `cd ios && pod install && cd ..`

### Issue: "FirebaseOptions not configured" error

**Solution:**
1. Run `flutterfire configure` again
2. Select all platforms you need
3. Verify `lib/firebase_options.dart` is created
4. Run `flutter clean && flutter pub get`

## Testing the App

1. **Launch the app** - You should see a splash screen with an API icon
2. **Login screen** - After splash, you'll see Google Sign-In button
3. **Sign in** - Tap "Sign in with Google" and complete authentication
4. **Home screen** - You should now see the API request interface
5. **Test an API** - Try a simple GET request to `https://jsonplaceholder.typicode.com/todos/1`
6. **View response** - You should see a 200 status and JSON response
7. **Check history** - Switch to History tab to see your saved request
8. **Toggle theme** - Tap the theme icon to switch between light/dark mode

## Next Steps

Once everything is working:

1. **Customize the app** - Modify themes, colors, and UI as needed
2. **Add features** - Implement additional functionality
3. **Test thoroughly** - Try different API endpoints and methods
4. **Build for release** - Follow the README for production builds

## Support

If you encounter issues:
1. Check the troubleshooting section in README.md
2. Review Firebase Console for any configuration warnings
3. Check Flutter and Firebase documentation
4. Ensure all dependencies are up to date: `flutter pub upgrade`

Happy coding! 🚀
