# Pocket Recovery Vault

## What Is Included

- A stable public widget-test entrypoint at `lib/pocket_recovery_vault_app.dart`
- Injectable service interfaces for local storage, clipboard access, and secure-screen handling
- Widget key definitions centralized in `lib/widget_keys.dart`
- Fixed vault category and plain vault item types in `lib/vault_item.dart`
- Screen files for setup, unlock, home, editor, and detail structure
- `cryptography` included because the final solution must implement AES-256-GCM and PBKDF2-HMAC-SHA256 locally

## Implementation Notes

- Runtime behavior for setup, unlock, lock, search, CRUD, detail actions, and persistence is intentionally omitted here.
- Keep the widget keys and user-visible strings from the prompt stable even if you restructure the UI.
- Keep the public test builder in `lib/pocket_recovery_vault_app.dart` stable. Acceptance tests should import that library instead of `main.dart`.
- The injected storage seam is part of the grading contract. The raw document written through that seam must satisfy the persisted vault document contract from the task prompt, including the JSON field names used for security metadata.

## Automated Widget Acceptance Contract

- The app must support widget-test execution without requiring real device plugins.
- Production dependencies may be wired in `main()`, but tests must be able to build the app through `buildPocketRecoveryVaultApp(...)` in `lib/pocket_recovery_vault_app.dart` using alternate local storage, clipboard access, and secure-screen handling implementations.
- The app's business logic, state transitions, repository logic, and UI behavior must remain the same regardless of which dependency implementations are supplied.
- Keyed actions whose enabled or disabled state is part of the contract must expose matching enabled-state semantics. Tests will not depend on a specific button widget class.
- For acceptance tests, a widget is considered visible when present in the widget tree and reachable by scrolling if necessary.


## Prerequisites

- Flutter `3.35.7`
- Dart `3.9.2`
- Android SDK or Android Studio configured on the machine
- Android target SDK `36` and minimum SDK `29`

## Setup And Run

1. Install the Android SDK or Android Studio and ensure the Android SDK path is configured.
2. Use Flutter `3.35.7`.
3. Disable non-Android Flutter targets once on this machine:

```sh
flutter config --no-enable-ios --no-enable-web --no-enable-macos-desktop --no-enable-linux-desktop --no-enable-windows-desktop --enable-android
```

4. From this folder, run `flutter pub get`.
5. Run `flutter run -d <android-device-id>`.
