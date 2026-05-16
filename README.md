# N:OW - A Mindful Moments App

N:OW is a cross-platform mobile application built with Flutter, designed to help users cultivate mindfulness and calm through meditation and mindful exercises. The app features a clean, intuitive interface and modular architecture for easy contribution and scalability.

## Feature List

- **Authentication**: Secure phone number authentication using Firebase OTP.
- **Meditation Timer**: Guided meditation sessions with a customizable timer.
- **Mindful Bells**: Plays bells at intervals to encourage mindful awareness.
- **Angel Numbers**: Displays and explains angel numbers for spiritual insight.
- **Settings**: Personalize themes, preferences, and app behavior.
- **Light/Dark Themes**: Switch between light and dark modes for comfort.
- **About**: Learn about the app and Paper Huts.

## Project Layout

The app is organized in a feature-based architecture. For detailed information regarding the implementation details, directory structure, and state management, please refer to the [Project Structure Documentation](docs/project_structure.md).

## Setup & Installation

To get started with the project locally:

1. **Clone the repository**: 
   ```bash
   git clone <repository-url>
   ```
2. **Install dependencies**: 
   ```bash
   flutter pub get
   ```
3. **Configure Firebase**:
   - This project uses Firebase Authentication. Ensure you have the proper `google-services.json` (for Android) and `GoogleService-Info.plist` (for iOS) configured in their respective directories.
4. **Run the app**: 
   ```bash
   flutter run
   ```

### Notes
- The About page uses `url_launcher` to open the external website in the system browser.

## Contribution Guidelines

- Check the `docs/` folder for architectural patterns and structural guidelines.
- Organize new features under `lib/features/<feature_name>/`
- Use providers for state management, placing them in `lib/providers/` or `lib/features/<feature>/providers/`
- Write tests in the `test/` directory

We look forward to your contributions!
