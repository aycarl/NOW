# AGENTS.md — AI Coding & Release Operations Guide for N:OW

Welcome to **N:OW (`com.paperhuts.now`)**, a cross-platform mindfulness companion built with Flutter (`iOS`, `Android`, `macOS`, `Windows`, `Linux`, and `Web`). Any AI coding agent or contributor working in this repository MUST read and follow these guidelines before modifying code, design tokens, tests, or release pipelines.

---

## 1. Product Philosophy & Design System ("Less is More" / The Tao)

N:OW embodies the Taoist principle of **90% Emptiness (*Ma*)** and **Effortless Action (*Wu Wei*)**.

### Mandatory UI/UX Rules
1. **Never Hardcode Colors**:
   - Always read theme tokens from `TaoPalette.of(context)` defined in [`lib/core/theme/tao_theme.dart`](lib/core/theme/tao_theme.dart).
   - Every screen must support both **Washi Light (Yang)** (`#EBE7DF` stone paper, `#5C6658` bamboo sage) and **Obsidian Night (Yin / Dark Mode)** (`#111312` mineral charcoal, `#D4AF73` temple gold) toggled via `ThemeProvider` in [`SettingsPage`](lib/features/settings/pages/settings_page.dart).
   - Full hex/RGB/HSL brand tokens are documented in [`docs/design_system.md`](docs/design_system.md).
2. **Progressive Disclosure via the Whisper Capsule**:
   - Do not clutter the primary `MeditationTimerPage` canvas with permanent sliders, dropdowns, or multi-row button grids.
   - Keep session parameters consolidated inside the single **Whisper Capsule** (`key: Key('whisper_capsule_button')`) which opens the frosted-glass **Session Attunement** modal bottom sheet.
3. **Shared Home & Countdown Sanctuary**:
   - The resting Home screen and active Countdown screen share the same central **Breathing Orb** (`key: Key('breathing_orb_button')`) and ultra-thin `10:00` countdown digits.
   - When `_isSessionActive` is `true`, all surrounding chrome (`AppBar`, contemplation quote, Whisper Capsule, and peeking bottom card) must dissolve (`AnimatedOpacity -> 0.0` + `IgnorePointer`).
4. **Sacred Acoustic Symbols (`ZenSoundSymbol`)**:
   - Always represent bell sounds using [`ZenSoundSymbol`](lib/core/widgets/zen_sound_symbol.dart) (`Enso Circle` for `singing_bowl`, `Concentric Ripple` for `default`/`gong`, `Dewdrop` for `chime`, `Flowing Wave` for `nature`).

---

## 2. Codebase Architecture & Key Files

```text
NOW/
├── lib/
│   ├── main.dart                                 # App entry point, MultiProvider, TaoTheme.light()/dark()
│   ├── core/
│   │   ├── theme/tao_theme.dart                  # TaoPalette ThemeExtension (Yang Washi & Yin Obsidian)
│   │   └── widgets/zen_sound_symbol.dart         # Sacred geometry CustomPainter for bell sounds
│   ├── features/
│   │   ├── home/carousel_home_page.dart          # Stacked Cards (Stack + AnimatedPositioned) container
│   │   ├── meditation_timer/meditation_timer_page.dart # Breathing Orb, Whisper Capsule, Attunement Sheet
│   │   ├── mindful_bells/pages/mindful_bells_page.dart # Peeking bottom tab + hairline bell list
│   │   ├── angel_numbers/angel_numbers_page.dart # Optional Angel Numbers bell schedule
│   │   └── settings/pages/settings_page.dart     # Dark Mode (Yin/Yang), Max Bells, Angel Numbers toggles
│   └── providers/theme_provider.dart             # Persists Dark Mode state via SharedPreferences
├── docs/
│   ├── design_system.md                          # Canonical brand colors, typography & motion spec
│   ├── ci_cd_release_guide.md                    # SemVer Release Please & CI/CD documentation
│   └── features/                                 # Structured feature specs (index.md, tao_ui_ux_concept.md, etc.)
├── test/
│   ├── helpers/test_helpers.dart                 # Test wrapper with TaoTheme & MultiProvider
│   ├── unit/                                     # Business logic unit tests
│   └── widget/                                   # Widget tests for Home, Timer, Bells, Settings, Angel Numbers
└── .github/workflows/
    ├── ci.yml                                    # PR Commit Lint + flutter analyze + flutter test
    ├── release-please.yml                        # Google Release Please SemVer + Multi-platform builds
    └── docs.yml                                  # DartDoc + Feature Docs deployment to GitHub Pages
```

---

## 3. Local Development, Testing & Mobile-First Verification

### 3.1 Platform Build Guardrails (Critical)
- **Android Gradle JDK 21 Requirement**:
  - Android Studio's bundled JDK 25 (`25.0.3`) breaks Kotlin's version parser in Gradle 8.12 (`IllegalArgumentException: 25.0.3`).
  - [`android/gradle.properties`](android/gradle.properties) pins `org.gradle.java.home=/opt/homebrew/opt/openjdk@21/libexec/openjdk.jdk/Contents/Home`. On CI (`ubuntu-latest`), always use `actions/setup-java@v4` with `java-version: '21'`.
- **iOS Firebase Linkage (CocoaPods vs. SPM)**:
  - Do **not** add Swift Package Manager (`firebase-ios-sdk`) references to `ios/Runner.xcodeproj/project.pbxproj` while CocoaPods (`ios/Podfile`) is managing Firebase plugins. Duplicate linkage causes a fatal runtime cast crash (`Could not cast value of type 'FirebaseAuth.Auth' to 'FirebaseAuth.Auth'`).
  - Keep `platform :ios, '15.0'` in `ios/Podfile`.
- **Infinite Animations in Widget Tests (`pumpAndSettle`)**:
  - Any repeating ambient animation (such as `_breathController` in `MeditationTimerPage`) MUST check `WidgetsBinding.instance.runtimeType.toString().contains('Test')` and set a static value (`0.5`) during widget tests so `tester.pumpAndSettle()` never times out.

### 3.2 Mobile-First Emulator & Simulator Verification
Always verify UI changes on **both** mobile platforms (not just macOS desktop) and in **both** Light and Dark modes:
1. **Android Emulator (`Pixel 9`)**:
   ```bash
   ~/Library/Android/sdk/emulator/emulator -avd Pixel_9 -no-snapshot-load &
   flutter run -d emulator-5554
   ```
2. **iOS Simulator (`iPhone 16 Pro`)**:
   ```bash
   xcrun simctl boot "iPhone 16 Pro"
   flutter run -d "iPhone 16 Pro"
   ```
3. **Static Analysis & Automated Tests (Required before every PR)**:
   ```bash
   flutter analyze
   flutter test test/unit test/widget
   ```

---

## 4. Automated SemVer Releases (`release-please`) & Git Workflow

- **Branching & Commits**:
  - Create feature branches (`feat/<topic>`, `fix/<topic>`, `refactor/<topic>`) targeting `main`.
  - All commit messages and PR titles MUST follow [Conventional Commits](https://www.conventionalcommits.org/):
    - `feat:` $\rightarrow$ Minor version bump (`1.0.0 -> 1.1.0`)
    - `fix:`, `perf:`, `refactor:`, `docs:` $\rightarrow$ Patch version bump (`1.0.0 -> 1.0.1`)
    - `feat!:` or `BREAKING CHANGE:` $\rightarrow$ Major version bump (`1.0.0 -> 2.0.0`)
- **Never Manually Bump `pubspec.yaml` for Releases**:
  - Google's [`release-please-action@v4`](.github/workflows/release-please.yml) automatically maintains a living Release PR (`chore(main): release X.Y.Z`) that updates `pubspec.yaml`, `.release-please-manifest.json`, and `CHANGELOG.md`.
  - Monotonic store build numbers (`+N`) are injected automatically in CI via `--build-number=${{ github.run_number }}`.

---

## 5. Multi-Store Deployment Considerations & Checklists

When preparing N:OW for production store submissions across mobile and desktop platforms, agents and engineers must account for the following platform-specific requirements:

### 5.1 Google Play Store (Android — `.aab`)
- **Application ID**: `com.paperhuts.now` (configured in `android/app/build.gradle.kts`).
- **Play App Signing & Upload Keystore**:
  - Replace debug signing in `android/app/build.gradle.kts` with a `release` signing config reading from `key.properties` / CI environment variables (`ANDROID_KEYSTORE_BASE64`, `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`).
- **Permissions & Policy Compliance for Mindfulness Timers/Bells**:
  - `POST_NOTIFICATIONS` (Android 13+ runtime permission for Mindful Bells).
  - `WAKE_LOCK` and `FOREGROUND_SERVICE` / `FOREGROUND_SERVICE_MEDIA_PLAYBACK` (so meditation countdown audio and bells chime reliably when the screen is off).
  - Prefer `USE_EXACT_ALARM` (or inexact alarms with user opt-in) carefully documented for Google Play's Exact Alarm policy review.
- **Automated Track Deployment**:
  - Use `r0adkll/upload-google-play@v1` in `.github/workflows/release-please.yml` with `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON` to push `app-release.aab` to the `internal` track on release creation.

### 5.2 Apple App Store & TestFlight (iOS — `.ipa`)
- **Bundle Identifier**: `com.paperhuts.now` (Minimum iOS Deployment Target: `15.0`).
- **Entitlements & `Info.plist` Requirements**:
  - `UIBackgroundModes`: `audio` and `fetch` / `remote-notification` so active meditation sessions and scheduled bells function when the device is locked.
  - **Privacy Manifest (`ios/Runner/PrivacyInfo.xcprivacy`)**: Mandatory for App Store submission (declare `NSPrivacyAccessedAPICategories` for `UserDefaults` / `SharedPreferences`).
  - Encryption Export Compliance: Add `ITSAppUsesNonExemptEncryption = NO` to `ios/Runner/Info.plist` to skip manual export compliance prompts on every TestFlight build.
- **Automated Signing & TestFlight Upload**:
  - Use App Store Connect API Key (`APP_STORE_CONNECT_API_KEY_ID`, `APP_STORE_CONNECT_ISSUER_ID`, `APP_STORE_CONNECT_API_KEY_BASE64`) with `flutter build ipa --release` and `xcrun altool` / Fastlane `pilot` to upload directly to TestFlight.

### 5.3 Desktop App Stores (macOS, Windows, Linux)

#### A. Mac App Store & Notarized Direct Download (`macOS`)
- **Deployment Target**: macOS `12.0` (`macos/Podfile` & `macos/Runner.xcodeproj`).
- **App Sandbox Entitlements (`macos/Runner/Release.entitlements`)**:
  - `com.apple.security.app-sandbox = true`
  - `com.apple.security.network.client = true` (required for Firebase Auth / Firestore sync).
- **Distribution Channels**:
  - **Mac App Store / TestFlight for Mac**: Sign with `3rd Party Mac Developer Application` & `3rd Party Mac Developer Installer` certificates and package as `.pkg` via `productbuild`.
  - **Direct Download (`.dmg` / `.app.zip`)**: Sign with `Developer ID Application` (Hardened Runtime enabled) and notarize via `xcrun notarytool submit --wait`, followed by `xcrun stapler staple`.

#### B. Microsoft Store (`Windows` — `.msix`)
- **MSIX Packaging**:
  - Add the [`msix`](https://pub.dev/packages/msix) dev dependency in `pubspec.yaml` with `identity_name`, `publisher`, and `publisher_display_name` matching the Microsoft Partner Center account.
  - Build with `flutter build windows --release && dart run msix:create`.
  - Note on Firebase on Windows: Guard any unsupported mobile-only plugins using `defaultTargetPlatform` or web/REST fallbacks.

#### C. Linux App Stores (`Snapcraft` & `Flathub`)
- **Snap Store (`snap/snapcraft.yaml`)**:
  - Confinement: `strict` with plugs for `network`, `audio-playback`, and `desktop-legacy`.
  - Build via `flutter build linux --release` and `snapcraft`.
- **Flathub (`com.paperhuts.now.yml`)**:
  - Package the `build/linux/x64/release/bundle` output with `org.freedesktop.Platform` runtime and PulseAudio (`--socket=pulseaudio`) permissions for bell acoustics.
