# Firebase Android Setup Guide

## Steps to Deploy Your App with Firebase

### 1. Get google-services.json from Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project (or create one)
3. Click the gear icon (⚙️) → **Project settings**
4. Scroll down to **Your apps** section
5. If you don't have an Android app registered:
   - Click **Add app** → **Android**
   - Register with package name: `com.example.fbla`
   - Download `google-services.json`
6. If you already have an Android app:
   - Click on your Android app
   - Download `google-services.json`

### 2. Place google-services.json

Copy the downloaded file to:

```
android/app/google-services.json
```

### 3. Update Android Gradle files (already done below)

The necessary Gradle plugin configurations will be added automatically.

### 4. Enable Firebase Services

In Firebase Console, enable:

- **Authentication** → Sign-in method → Enable Email/Password and Google
- **Cloud Firestore** → Create database (start in test mode for development)
- **Firebase Storage** → Get started (for file uploads)

### 5. Firebase Security Rules (Development)

For development, use these permissive rules (update before production):

**Firestore Rules:**

```
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

**Storage Rules:**

```
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 6. Run the app

After placing `google-services.json`:

```bash
flutter clean
flutter pub get
bash scripts/start-emulator-and-run.sh
```

## Troubleshooting

- **"Failed to load FirebaseOptions"** → Missing `google-services.json`
- **"Default FirebaseApp is not initialized"** → `google-services.json` in wrong location
- **Build fails** → Run `flutter clean` and rebuild
