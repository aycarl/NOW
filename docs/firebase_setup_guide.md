# Firebase Project & Multi-Platform Authentication Setup Guide

This guide explains how **N:OW (`com.paperhuts.now`)** is connected to its Firebase backend (`now-mindful-moments`), how to manage multi-platform app configurations (`Android`, `iOS`, `macOS`, `Web`, `Windows`), and how to configure **Firebase Authentication** (Phone SMS, Google Sign-In, Apple Sign-In, and Anonymous Auth) for production mobile and web deployments.

---

## 1. Current Firebase Project Inventory (`now-mindful-moments`)

Your Firebase project **`now-mindful-moments`** (Project Number: `976907246014`) is already provisioned and wired into [`lib/firebase_options.dart`](../lib/firebase_options.dart) and [`firebase.json`](../firebase.json) across 5 platforms:

| Platform | App Display Name | Firebase App ID | Package / Bundle ID | Config File Location |
| :--- | :--- | :--- | :--- | :--- |
| **Android** | `now (android)` | `1:976907246014:android:0bdefe9e3b431f09dd81ef` | `com.paperhuts.now` | [`android/app/google-services.json`](../android/app/google-services.json) |
| **iOS** | `now (ios)` | `1:976907246014:ios:05b895d30bdad929dd81ef` | `com.paperhuts.now` | [`ios/Runner/GoogleService-Info.plist`](../ios/Runner/GoogleService-Info.plist) |
| **macOS** | `now (ios)` | `1:976907246014:ios:05b895d30bdad929dd81ef` | `com.paperhuts.now` | [`macos/Runner/GoogleService-Info.plist`](../macos/Runner/GoogleService-Info.plist) |
| **Web** | `now (web)` | `1:976907246014:web:c0a6bfa32150e0e7dd81ef` | `now-mindful-moments.firebaseapp.com` | [`lib/firebase_options.dart`](../lib/firebase_options.dart) (`DefaultFirebaseOptions.web`) |
| **Windows** | `now (windows)` | `1:976907246014:web:d69017cac6934e80dd81ef` | `now-mindful-moments.firebaseapp.com` | [`lib/firebase_options.dart`](../lib/firebase_options.dart) (`DefaultFirebaseOptions.windows`) |

### Useful Firebase CLI Commands
Always invoke the Firebase CLI using `npx -y firebase-tools@latest`:
```bash
# 1. Verify your logged-in account
npx -y firebase-tools@latest login:list

# 2. List all registered apps in now-mindful-moments
npx -y firebase-tools@latest apps:list --project now-mindful-moments

# 3. Re-download Android or iOS config files programmatically (without visiting the Console)
npx -y firebase-tools@latest apps:sdkconfig ANDROID 1:976907246014:android:0bdefe9e3b431f09dd81ef --project now-mindful-moments > android/app/google-services.json
npx -y firebase-tools@latest apps:sdkconfig IOS 1:976907246014:ios:05b895d30bdad929dd81ef --project now-mindful-moments > ios/Runner/GoogleService-Info.plist
```

---

## 2. Setting Up Firebase Authentication Providers

### 2.1 Declarative Auth Provisioning via `firebase.json` (Anonymous, Email/Password, Google Sign-In)
You can enable Anonymous Auth (for "Continue without an account" cloud sync), Email/Password, and Google Sign-In directly from [`firebase.json`](../firebase.json) and deploy via the CLI:

```json
{
  "auth": {
    "providers": {
      "anonymous": true,
      "emailPassword": true,
      "googleSignIn": {
        "oAuthBrandDisplayName": "N:OW",
        "supportEmail": "aycarl.dev@gmail.com"
      }
    }
  }
}
```
Then deploy the Auth configuration to Firebase:
```bash
npx -y firebase-tools@latest deploy --only auth --project now-mindful-moments
```

### 2.2 Enabling Phone Number (SMS) Authentication
N:OW's [`AuthScreen`](../lib/auth_screen.dart) and [`AuthService`](../lib/auth_service.dart) use **Phone Number (OTP SMS) Authentication**. Because SMS delivery incurs carrier costs, Phone Auth requires the following setup in the [Firebase Console — Authentication > Sign-in method](https://console.firebase.google.com/project/now-mindful-moments/authentication/providers):

1. **Enable the Phone Provider**:
   - In **Authentication → Sign-in method**, click **Phone**, toggle **Enable**, and click **Save**.
2. **Add Test Phone Numbers for Free Local Development & CI**:
   - Under **Phone numbers for testing (optional)**, add a test number and fixed 6-digit OTP code (e.g., `+1 650-555-3434` $\rightarrow$ `123456`).
   - Test numbers bypass real SMS dispatch, reCAPTCHA, and quota limits on both iOS Simulators and Android Emulators.

---

## 3. Platform-Specific Requirements for Mobile & Web Auth

### 3.1 Android Deployment Requirements (SHA-1 & SHA-256 Fingerprints)
Firebase Phone Auth (Play Integrity API) and Google Sign-In on Android **require** your signing certificate's `SHA-1` and `SHA-256` fingerprints to be registered in Firebase. Without them, `verifyPhoneNumber` fails with `ERROR_INVALID_CERT_HASH` / `missing-client-identifier`.

1. **Get your Local Debug Keystore Fingerprints**:
   ```bash
   keytool -list -v -alias androiddebugkey \
     -keystore ~/.android/debug.keystore \
     -storepass android -keypass android | grep -E "SHA1:|SHA256:"
   ```
2. **Get your Production Upload Keystore Fingerprints**:
   ```bash
   keytool -list -v -alias upload \
     -keystore upload-keystore.jks | grep -E "SHA1:|SHA256:"
   ```
3. **Register Fingerprints via CLI (or Project Settings → Your Apps → Android)**:
   ```bash
   npx -y firebase-tools@latest apps:android:sha:create \
     1:976907246014:android:0bdefe9e3b431f09dd81ef <SHA_HASH> \
     --project now-mindful-moments
   ```
   *(After adding SHA fingerprints, re-run `npx -y firebase-tools@latest apps:sdkconfig ANDROID ... > android/app/google-services.json` so `oauth_client` entries are populated).*
4. **Google Play App Signing Fingerprint (Production)**:
   - Once published to Google Play Internal Testing, copy the **App signing key certificate (`SHA-1` & `SHA-256`)** from **Google Play Console → Setup → App integrity** and register it in Firebase as well.

---

### 3.2 iOS & macOS Deployment Requirements (APNs + URL Schemes)
On iOS, Firebase Phone Auth verifies the device using **silent Apple Push Notifications (APNs)** or a fallback reCAPTCHA verification flow.

1. **Upload an Apple Push Notification Authentication Key (`.p8`)**:
   - In [Apple Developer Portal → Keys](https://developer.apple.com/account/resources/authkeys/list), create a key with **Apple Push Notifications service (APNs)** enabled and download the `.p8` file, noting your **Key ID** and **Team ID**.
   - Upload the `.p8` key under [Firebase Console → Project Settings → Cloud Messaging → Apple app configuration](https://console.firebase.google.com/project/now-mindful-moments/settings/cloudmessaging).
2. **Add Reversed Client ID URL Scheme to `ios/Runner/Info.plist`**:
   - Open [`ios/Runner/GoogleService-Info.plist`](../ios/Runner/GoogleService-Info.plist) and copy the `REVERSED_CLIENT_ID` value.
   - Ensure it is registered under `CFBundleURLTypes` $\rightarrow$ `CFBundleURLSchemes` in `ios/Runner/Info.plist` so the reCAPTCHA fallback redirect can return to the app.
3. **Critical iOS Build Rule (CocoaPods Only)**:
   - As documented in [`AGENTS.md`](../AGENTS.md), never add Swift Package Manager (`firebase-ios-sdk`) in Xcode alongside CocoaPods (`ios/Podfile`). Let CocoaPods manage `FirebaseAuth` and `FirebaseCore` exclusively.

---

### 3.3 Web & GitHub Pages Deployment Requirements (`Authorized Domains`)
When N:OW runs on GitHub Pages (`https://aycarl.github.io/NOW/`), Firebase Auth checks whether the hostname is on the **Authorized Domains** allowlist.

1. Open [Firebase Console → Authentication → Settings → Authorized domains](https://console.firebase.google.com/project/now-mindful-moments/authentication/settings).
2. Ensure the following domains are listed (enter the **domain only**—no `https://` protocol, port, or `/NOW/` path):
   - `localhost` *(enabled by default for local testing)*
   - `now-mindful-moments.firebaseapp.com` *(enabled by default)*
   - `aycarl.github.io` *(add this so live GitHub Pages Web Auth works)*
   - Your custom production domain (if applicable, e.g., `paperhuts.com`)
