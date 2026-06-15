# Firebase Auth Demo (ITE 124)

A starter Flutter project for the **Firebase Basics** lecture. The UI for the
sign-in/sign-up screen and the home screen is already built. Your task in the
lecture is to connect this app to your own Firebase project and wire up
authentication.

## Prerequisites

- Flutter SDK installed (`flutter --version` works)
- A Google account (for the Firebase Console)
- Node.js installed (`node --version`) — the Firebase CLI runs on it
- An Android emulator, iOS simulator, or Chrome to run on

## Quick Start

```bash
flutter pub get
flutter run
```

The login screen should appear. The buttons won't do anything yet — you'll
connect them to Firebase during the lecture.

## What you'll do in class

1. Create a Firebase project and enable **Email/Password** authentication.
2. Run `flutterfire configure` to generate `lib/firebase_options.dart`.
3. Replace `lib/main.dart` with the Firebase-connected version.
4. Implement the `_submit()` method in `lib/screens/auth_screen.dart`.

## Project structure

- `lib/main.dart` — app entry point (starter version is NOT yet connected to Firebase)
- `lib/screens/auth_screen.dart` — sign-in / sign-up UI (the `_submit()` method is left empty for you)
- `lib/screens/home_screen.dart` — the screen shown after a successful login

## Important

Do **not** commit your `lib/firebase_options.dart`. It is specific to your own
Firebase project and is already listed in `.gitignore`.
