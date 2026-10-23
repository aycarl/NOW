# Automated SemVer Releases & Multi-Platform CI/CD Guide

This document defines the industry-standard release automation and multi-platform CI/CD architecture used by **N:OW** for mobile (`iOS` & `Android`), desktop (`macOS`), and living documentation (`GitHub Pages`).

---

## 1. Industry Standards for Multi-Platform Flutter Releases

### Dual Versioning: SemVer (`X.Y.Z`) + Monotonic Build Number (`+N`)
Unlike web apps, mobile and desktop app stores (**Apple App Store Connect** and **Google Play Console**) enforce two distinct version identifiers in `pubspec.yaml` (`version: X.Y.Z+N`):
1. **Marketing SemVer (`X.Y.Z`)**: Maps to `CFBundleShortVersionString` (iOS/macOS) and `versionName` (Android). Governed automatically by [Conventional Commits](https://www.conventionalcommits.org/).
2. **Monotonic Build Code (`+N`)**: Maps to `CFBundleVersion` (iOS/macOS) and `versionCode` (Android). App stores **reject** any binary upload whose build number is not strictly greater than the previous upload, even across patch/minor bumps. In CI, we inject `--build-number=${{ github.run_number }}` at build time so every release artifact has a guaranteed strictly-increasing integer build code without polluting git history.

### Google Release Please (`googleapis/release-please-action@v4`)
Instead of tagging releases on every single push to `main` (which creates noisy tags and premature store builds), **Google's Release Please** maintains a **living Release PR** (`chore(main): release X.Y.Z`):
- Every PR merged to `main` using Conventional Commits (`feat:`, `fix:`, `perf:`, `refactor:`, `docs:`) automatically updates the open Release PR's `pubspec.yaml` and `CHANGELOG.md`.
- When the team is ready to cut a release, simply **merging the Release PR** triggers `release-please` to create the signed Git tag (`vX.Y.Z`), publish the GitHub Release, and kick off the multi-platform binary build matrix.

---

## 2. Conventional Commit SemVer Mapping

| Commit Prefix | SemVer Impact | Changelog Section | Example |
| :--- | :--- | :--- | :--- |
| `feat:` | **MINOR** (`1.0.0 -> 1.1.0`) | Features | `feat(timer): add Whisper Capsule progressive disclosure` |
| `fix:` | **PATCH** (`1.0.0 -> 1.0.1`) | Bug Fixes | `fix(ios): remove duplicate SPM FirebaseAuth linkage` |
| `perf:` | **PATCH** (`1.0.0 -> 1.0.1`) | Performance Improvements | `perf(home): optimize Breathing Orb radial shader` |
| `refactor:` | **PATCH** | Code Refactoring | `refactor(theme): extract Yin & Yang TaoPalette extension` |
| `docs:` | **PATCH** | Documentation | `docs(tao): document Less is More UI/UX architecture` |
| `feat!:` / `BREAKING CHANGE:` | **MAJOR** (`1.0.0 -> 2.0.0`) | Breaking Changes | `feat(auth)!: migrate to passkey authentication` |
| `chore:` / `test:` / `ci:` | *No bump* | *(Hidden)* | `test(widget): add Stacked Cards home navigation tests` |

---

## 3. GitHub Actions Workflows

```
  PR Opened / Updated ──► [ci.yml]
                          ├─ Conventional Commit PR Title Lint
                          ├─ flutter analyze
                          └─ flutter test test/unit test/widget --coverage

  PR Merged to main ────► [release-please.yml]
                          └─ Opens / Updates "chore(main): release X.Y.Z" PR
                             (auto-updates pubspec.yaml + CHANGELOG.md)

  Release PR Merged ────► [release-please.yml] (release_created == 'true')
                          ├─ Creates GitHub Release + Tag vX.Y.Z
                          ├─ build-android: APK + Play Store AAB (--build-number=run_number)
                          └─ build-apple: macOS .app.zip + iOS unsigned .app.zip

  Push to main (docs/) ─► [docs.yml]
                          ├─ Generates Dart API Reference (dart doc)
                          ├─ Bundles docs/features/*.md + CHANGELOG.md
                          └─ Deploys to GitHub Pages
```

### Workflow Files
- **`.github/workflows/ci.yml`**: Runs on every pull request and feature branch push. Validates Conventional Commit PR titles, runs `flutter analyze`, and executes `flutter test test/unit test/widget --coverage`.
- **`.github/workflows/release-please.yml`**: Runs on pushes to `main`. Uses `googleapis/release-please-action@v4` with `release-please-config.json` (`release-type: dart`) and `.release-please-manifest.json`. When a Release PR is merged, builds and attaches Android (`.apk`, `.aab`), macOS (`.app.zip`), and iOS (`.app.zip`) release artifacts.
- **`.github/workflows/docs.yml`**: Automatically builds `dart doc` API documentation alongside `docs/features/` and publishes to GitHub Pages.

---

## 4. Configuring Store Signing Secrets (Production Deployment)

When ready to publish signed binaries directly to **TestFlight / App Store Connect** and **Google Play Internal Track**, add the following encrypted repository secrets under **GitHub Settings → Secrets and variables → Actions**:

### Android Signing Secrets
- `ANDROID_KEYSTORE_BASE64`: Base64-encoded upload keystore (`base64 -i upload-keystore.jks | pbcopy`)
- `ANDROID_KEYSTORE_PASSWORD`: Keystore password
- `ANDROID_KEY_ALIAS`: Upload key alias
- `ANDROID_KEY_PASSWORD`: Upload key password
- `GOOGLE_PLAY_SERVICE_ACCOUNT_JSON`: Google Play Console API Service Account JSON

### Apple (iOS & macOS) Signing Secrets
- `APP_STORE_CONNECT_API_KEY_ID`: App Store Connect API Key ID
- `APP_STORE_CONNECT_ISSUER_ID`: App Store Connect Issuer UUID
- `APP_STORE_CONNECT_API_KEY_BASE64`: Base64-encoded `.p8` API private key
- `APPLE_CERTIFICATE_BASE64`: Base64-encoded Distribution `.p12` certificate
- `APPLE_CERTIFICATE_PASSWORD`: Password for the `.p12` certificate
- `APPLE_PROVISIONING_PROFILE_BASE64`: Base64-encoded `.mobileprovision` profile
