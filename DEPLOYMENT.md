# 🚀 Deployment Guide - FBLA Connect App

## Current Status

✅ **Completed:**

- Android emulator setup and configuration
- Flutter app structure and dependencies
- Authentication UI and services
- Google Sign-In API updated to v7.2.0
- Android Gradle configured for Firebase

❌ **Required Before Deployment:**

- Firebase configuration (google-services.json)

---

## Quick Start - Deploy to Android Emulator

### Step 1: Configure Firebase

You need to add your Firebase configuration file:

```bash
# Check if Firebase is configured
bash scripts/check-firebase.sh
```

If not configured, follow these steps:

1. **Go to Firebase Console:** https://console.firebase.google.com/
2. **Select/Create Project:**
   - Create a new project or select existing
   - Name: "FBLA Connect" (or your choice)
3. **Add Android App:**
   - Click gear icon → Project settings
   - Scroll to "Your apps" → Add app → Android
   - Package name: `com.example.fbla`
   - Click "Register app"
4. **Download google-services.json:**
   - Download the file provided by Firebase
   - Place it at: `android/app/google-services.json`
5. **Enable Firebase Services:**
   - **Authentication:** Enable Email/Password and Google sign-in
   - **Firestore:** Create database (start in test mode)
   - **Storage:** Enable for file uploads

### Step 2: Deploy to Emulator

```bash
# Start emulator and run app
bash scripts/start-emulator-and-run.sh
```

Or use VS Code:

1. Press `F5` or click "Run and Debug"
2. Select "Flutter (fbla)" configuration

### Step 3: Verify Deployment

The app should:

- ✅ Launch on the emulator
- ✅ Show the splash/login screen
- ✅ Allow authentication (once Firebase is configured)

---

## Alternative: Deploy Without Firebase (Testing Only)

If you want to test the UI without Firebase:

1. Comment out Firebase initialization in `lib/main.dart`:

```dart
// await Firebase.initializeApp();
```

2. Run the app:

```bash
flutter run -d emulator-5554
```

**Note:** Authentication and data features won't work without Firebase.

---

## Deploy to Physical Device

### Android Phone

1. Enable Developer Options on your phone:

   - Settings → About phone → Tap "Build number" 7 times
   - Settings → Developer options → Enable "USB debugging"

2. Connect phone via USB

3. Verify device:

```bash
adb devices
```

4. Run app:

```bash
flutter run
```

### iOS Device (Mac only)

1. Open `ios/Runner.xcworkspace` in Xcode
2. Select your development team
3. Connect iPhone via USB
4. Select your device in Xcode
5. Click Run (▶️) or use:

```bash
flutter run -d <device-id>
```

---

## Build Release APK (Android)

```bash
# Build release APK
flutter build apk --release

# APK location:
# build/app/outputs/flutter-apk/app-release.apk
```

Install on device:

```bash
adb install build/app/outputs/flutter-apk/app-release.apk
```

---

## Build for iOS (Mac only)

```bash
# Build iOS archive
flutter build ipa

# Archive location:
# build/ios/archive/Runner.xcarchive
```

Submit to App Store via Xcode or:

```bash
xcrun altool --upload-app --file build/ios/ipa/*.ipa
```

---

## Troubleshooting

### "Failed to load FirebaseOptions"

- **Cause:** Missing or incorrect `google-services.json`
- **Fix:** Download from Firebase Console and place at `android/app/google-services.json`

### "Namespace not specified"

- **Cause:** Outdated plugin versions
- **Fix:** Already fixed in `pubspec.yaml` (share_plus, sign_in_with_apple updated)

### Emulator won't start

```bash
# Check if emulator exists
emulator -list-avds

# If missing, create one:
bash scripts/setup-android-emulator.sh
```

### Build fails with Gradle errors

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

---

## Next Steps After Deployment

1. **Test Authentication:**

   - Email/password signup
   - Google Sign-In
   - Password reset

2. **Test Features:**

   - Events listing and detail
   - News feed
   - Resources section
   - Profile management

3. **Configure Firebase Rules:**

   - See `FIREBASE_SETUP.md` for security rules
   - Update rules before production deployment

4. **Production Checklist:**
   - [ ] Update package name from `com.example.fbla`
   - [ ] Add app signing configuration
   - [ ] Configure Firebase security rules
   - [ ] Test on multiple devices
   - [ ] Add app icons and splash screens
   - [ ] Submit to Google Play / App Store

---

## Quick Reference Commands

```bash
# Check Firebase config
bash scripts/check-firebase.sh

# Start emulator and run
bash scripts/start-emulator-and-run.sh

# Run on specific device
flutter devices
flutter run -d <device-id>

# Build release
flutter build apk --release        # Android
flutter build ipa --release        # iOS

# Clean build
flutter clean && flutter pub get

# Check for issues
flutter doctor -v
flutter analyze
```

---

## Support

For detailed Firebase setup, see: `FIREBASE_SETUP.md`

For Android emulator issues, see: `README-CURSOR-SETUP.md`
