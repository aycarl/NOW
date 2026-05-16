# Project Structure

N:OW is structured using feature-based folders, leveraging the `provider` package for state management, `shared_preferences` for local storage, and `firebase_auth` for authentication. The app is organized for maintainability and extensibility.

## Directory Layout

```text
lib/
  main.dart                # App entry point
  splash_screen.dart       # Initial splash screen
  auth_screen.dart         # Phone number authentication screen
  otp_screen.dart          # OTP verification screen
  auth_service.dart        # Firebase authentication logic
  features/
    angel_numbers/         # Angel numbers feature
    home/                  # Home screen and carousel
    meditation_timer/      # Meditation timer feature
    mindful_bells/         # Mindful bells feature
    settings/
      pages/               # Settings UI pages (incl. About)
      providers/           # Settings state management
  providers/
    theme_provider.dart    # Global theme provider
```

## Key Folders

- `lib/`: Contains the main Dart source code, separated by features and global providers.
- `android/`, `ios/`, `macos/`: Platform-specific files and configurations.
- `test/`: Unit, widget, and integration tests.
- `docs/`: Project documentation and architecture details.

## Implementation Details

- **State Management**: The app uses `provider` to handle both global state (like `ThemeProvider`) and feature-specific state (like `SettingsProvider`).
- **Authentication**: Handled via `firebase_auth` using Phone Number Verification. The flow goes from `SplashScreen` -> `AuthScreen` -> `OTPScreen` -> `CarouselHomePage`.
- **Navigation**: Uses basic Material routing for simple transitions and feature discovery.
