# N:OW - A Mindful Moments App

N:OW is a cross-platform mobile application built with Flutter, designed to help users cultivate mindfulness and calm through meditation and mindful exercises. The app features a clean, intuitive interface and modular architecture for easy contribution and scalability.

## Project Summary

N:OW is structured using feature-based folders, leveraging the `provider` package for state management and `shared_preferences` for local storage. The app supports Android and iOS, and is organized for maintainability and extensibility.

## Feature List

- **Meditation Timer**: Guided meditation sessions with a customizable timer.
- **Mindful Bells**: Plays bells at intervals to encourage mindful awareness.
- **Angel Numbers**: Displays and explains angel numbers for spiritual insight.
- **Settings**: Personalize themes, preferences, and app behavior.
- **Light/Dark Themes**: Switch between light and dark modes for comfort.

## Updated Project Structure

```
lib/
  main.dart                # App entry point
  features/
    angel_numbers/         # Angel numbers feature
    home/                  # Home screen and carousel
    meditation_timer/      # Meditation timer feature
    mindful_bells/         # Mindful bells feature
    settings/
      pages/               # Settings UI pages
      providers/           # Settings state management
  providers/
    theme_provider.dart    # Global theme provider
  shared/                  # Shared widgets/utilities (currently empty)
```

Other key folders:
- `android/` and `ios/`: Platform-specific files
- `test/`: Unit, widget, and integration tests

## For New Contributors

Welcome! To get started:

1. **Clone the repository**: `git clone <repository-url>`
2. **Install dependencies**: `flutter pub get`
3. **Run the app**: `flutter run`

### Contribution Guidelines
- Organize new features under `lib/features/<feature_name>/`
- Use providers for state management, placing them in `lib/providers/` or `lib/features/<feature>/providers/`
- Share reusable widgets/utilities in `lib/shared/`
- Write tests in the `test/` directory

We look forward to your contributions!
