# N:OW - A Mindful Moments App

N:OW is a mobile application built with Flutter, designed to help users find moments of mindfulness and calm in their daily lives. The app provides a simple and elegant interface with tools for meditation and mindfulness exercises.

## Project Summary

The project is a Flutter application that currently supports Android and iOS. It is built with a focus on simplicity and a clean user interface. The app's core functionality revolves around a carousel-style home page that allows users to switch between a meditation timer and a mindful bells feature. State management is handled using the `provider` package, and user preferences are stored locally using `shared_preferences`.

## Feature List

*   **Meditation Timer**: A simple timer to help users with their meditation sessions.
*   **Mindful Bells**: A feature that plays mindful bells at set intervals.
*   **Light and Dark Themes**: The app supports both light and dark modes for user comfort.
*   **Settings Page**: A dedicated page for users to customize their experience.
*   **Angel Numbers**: A feature to display and explain angel numbers.

## For New Contributors

Welcome to the N:OW project! We're excited to have you. Here's a quick guide to get you started:

### Getting Started

1.  **Clone the repository**: `git clone <repository-url>`
2.  **Install dependencies**: `flutter pub get`
3.  **Run the app**: `flutter run`

### Project Structure

The project is structured by feature to promote scalability and maintainability.

*   `lib/`: This directory contains all the Dart code for the application.
    *   `main.dart`: The entry point of the application.
    *   `features/`: Contains the individual features of the app, each in its own directory.
        *   `angel_numbers/`: The angel numbers feature.
        *   `home/`: The main home screen of the app.
        *   `meditation_timer/`: The meditation timer feature.
        *   `mindful_bells/`: The mindful bells feature.
        *   `settings/`: The settings feature.
    *   `providers/`: Contains global state management providers.
    *   `shared/`: Contains widgets and utilities shared across multiple features.
*   `android/`: Android-specific files.
*   `ios/`: iOS-specific files.
*   `test/`: Contains all the tests for the application.

We look forward to your contributions!
