# FBLA Connect

FBLA Connect is a cross-platform Flutter app scaffold built for FBLA chapters to share news, events, and resources. The project follows MVVM + Repository architecture with Riverpod for state management and GoRouter for navigation. Firebase (Auth, Firestore, Storage) is integrated at the code level; you need to add platform Firebase config files to run end-to-end.

## Table of contents
- Project architecture
- Key screens and user journey
- Third-party packages
- Setup (dependencies & Firebase)
- Running, testing, and building
- UX rationale & accessibility
- Files of interest
- Mockups / screenshots

---

## Project architecture (MVVM + Repository)

High-level overview:

- Models: data classes representing domain entities (e.g., `lib/src/models/post_model.dart`, `event_model.dart`, `resource_model.dart`, `user_model.dart`).
- ViewModels: Riverpod providers and ChangeNotifier classes that encapsulate UI state and business logic (`lib/src/viewmodels/*`).
- Views: Flutter widgets and screens that render UI (`lib/src/views/*`).
- Repositories: data access abstraction (`lib/src/repositories/repository.dart`) with two implementations:
  - `InMemoryRepository` — seeded demo data for local testing.
  - `FirestoreRepository` — Firestore-backed implementation with offline persistence and simple caching.
- Services: encapsulate platform features (Auth, Storage, Sharing) under `lib/src/services/`.
- Routing: `GoRouter` is used; the app uses a `ShellRoute` to provide a shared `Scaffold` with a bottom navigation bar.

Contract and error modes:
- Repository methods return Future results or null when appropriate. Errors bubble up and are surfaced in views as error states.
- ViewModels expose loading/error state and provide refresh methods.

Edge cases considered:
- Offline support via Firestore persistence and in-memory caching.
- Empty lists and network errors are surfaced to the user with retry options in views.

---

## Key screens and user journey

- Home / News Feed: read and create posts (floating action button). Posts can be shared to other apps.
- Events / Calendar: view upcoming events, RSVP (demo placeholder), and share event details.
- Resources: search and filter by category, open PDF/media (external), and view details.
- Profile: edit profile fields and (optional) upload avatar to Firebase Storage.

Typical flow
1. User opens the app and lands on News Feed.
2. Use the bottom navigation to switch between Events, Resources, and Profile.
3. Use the FAB to create a new post, or tap a post/event to open details and use the share action.

---

## Third-party packages and libraries

Key dependencies (as declared in `pubspec.yaml`):

- flutter_riverpod — state management (providers, ChangeNotifier wiring).
- go_router — declarative navigation and deep linking.
- firebase_core, firebase_auth, cloud_firestore, firebase_storage — Firebase services.
- google_sign_in, sign_in_with_apple — social sign-in providers.
- url_launcher — open external URLs (resources, social links).
- share_plus — native share sheets for iOS & Android.
- cached_network_image — efficient remote image loading and caching.
- uuid — simple UUID generation for in-memory demo data.
- intl — date and localization utilities.

Development tools and lints:
- flutter_lints — recommended lint rules.

Note: package versions in `pubspec.yaml` may be older than the latest available; run `flutter pub outdated` and update selectively where needed.

---

## Setup

1) Prerequisites

- Flutter SDK (follow official install instructions).
- Platform toolchains for the platforms you target (Android SDK, Xcode for iOS).

2) Install dependencies

Run:

```bash
flutter pub get
```

3) Firebase configuration (required for Auth/Firestore/Storage)

- Create a Firebase project in the Firebase console.
- Add Android and/or iOS apps to the Firebase project.
- For Android, download `google-services.json` and place it under `android/app/`.
- For iOS, download `GoogleService-Info.plist` and add it to `ios/Runner/` and ensure it's included in Xcode.
- Update Android Gradle and iOS project per Firebase setup docs (the project already includes comments and typical wiring). You can refer to the official FlutterFire docs: https://firebase.flutter.dev/docs/overview
- (Optional) In the Firestore rules, add conservative security rules that allow read access to public resources but require auth for profile writes. Example rules are suggested in this repo's docs (add file `firestore.rules` as needed).

4) Enable platform-specific sign-in

- Google Sign-In: follow plugin docs and update OAuth redirect / SHA keys for Android.
- Apple Sign-In: requires enabling Sign in with Apple in your Apple Developer account and Xcode project updates.

5) Toggle repository implementation for real data

- The app uses `repositoryProvider` to choose between `InMemoryRepository` and `FirestoreRepository`. Change the provider in `lib/src/providers.dart` to use Firestore when ready.

---

## Running, testing, and building

- Run on an emulator or device:

```bash
flutter run
```

- Analyze code (static analysis):

```bash
flutter analyze
```

- Run tests (if any):

```bash
flutter test
```

- Build release APK:

```bash
flutter build apk --release
```

- Build iOS (from macOS with Xcode):

```bash
flutter build ios --release
```

CI notes
- Use `flutter analyze` and `flutter test` in your CI pipeline. For compatibility matrix tests, run on both stable and beta channels if necessary.

---

## UX rationale

- Goals: quick access to news & events, easy sharing, searchable resources, and a profile area for personalization.
- Bottom navigation is used to expose 4 primary sections for ease of reachability on mobile.
- Lightweight list cards reduce cognitive load and match native platform conventions (Material 3).
- Shared content uses the device's native share sheet for maximum reach and user familiarity.

Accessibility
- Colors use Material color schemes and respect `ThemeMode` so users can choose dark or light for readability.
- Text fields and buttons use semantic labels (where appropriate) and follow platform tap size guidelines.
- Keyboard accessibility: forms are simple text fields that support screen readers. We should run an accessibility audit on iOS VoiceOver and Android TalkBack to catch any missing labels. I can scaffold semantics if you'd like.

---

## Files of interest

- `lib/main.dart` — app entry, ProviderScope, Firebase initialization, router & theme wiring.
- `lib/src/app_router.dart` — GoRouter wiring and BottomNavigationBar ShellRoute.
- `lib/src/theme/app_theme.dart` — light/dark ThemeData and `themeModeProvider`.
- `lib/src/repositories` — `repository.dart`, `in_memory_repository.dart`, and `firestore_repository.dart`.
- `lib/src/viewmodels` — viewmodels for posts, events, resources.
- `lib/src/views` — UI screens and widgets.
- `lib/src/services` — `auth_service.dart`, `storage_service.dart`, `share_service.dart`.

---

## Mockups / Screenshots

Below are simple ASCII-style mockups that illustrate the layout for three main modules. You can replace these with real screenshots later.

News Feed

```
-------------------------------------------------
| AppBar: FBLA Connect       [calendar][menu]     |
-------------------------------------------------
| Card: Post content...                        >|
| by local_user         [♥ 12]   [share]         |
-------------------------------------------------
| Card: Another announcement...                >|
| by advisor            [♥ 3]    [share]         |
-------------------------------------------------
|              FloatingActionButton (+)         |
-------------------------------------------------
```

Resources

```
-------------------------------------------------
| AppBar: Resources                             |
-------------------------------------------------
| [search field....................] [icon]     |
| [Dropdown: All v]                             |
-------------------------------------------------
| Card: FBLA Guide (Guides)     [open] [share]   |
| Card: Presentation Templates   [open] [share]  |
-------------------------------------------------
```

Social / Sharing

```
Tap share on a post/event -> native share sheet -> select platform (Messages, Mail, Instagram, etc.)
```

---

If you'd like, I can:
- Add actual screenshots/screenshots placeholders to `assets/` and reference them in this README.
- Add more detailed Firebase security rules examples and a `firestore.rules` file.
- Add an accessibility checklist and run through a quick audit.

If you want me to commit any of these follow-ups, tell me which one to do next.

Android emulator helper script
---------------------------------
I included a helper shell script at `scripts/setup-android-emulator.sh` which automates:

- Downloading the Android command-line tools (macOS build)
- Installing `platform-tools`, `emulator`, `build-tools`, and an Android 33 system image
- Accepting licenses
- Creating an AVD named `fbla_pixel_33`

How to use:

```bash
chmod +x scripts/setup-android-emulator.sh
bash scripts/setup-android-emulator.sh
```

After the script completes, start the emulator with:

```bash
$ANDROID_SDK_ROOT/emulator/emulator -avd fbla_pixel_33
```

If you prefer to install components manually, see the "Android emulator setup" section earlier in this README (PATH and manual steps).
# fbla

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
