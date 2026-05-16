# Feature list

A mindful alert / alarm to remind yourself to be mindful and rooted within- Has a selection of temple bells, chimes, soothing sounds, nature sounds.
Simple, peaceful user interface
Soothing animations

## Core Features

The app has several core features:

### Sound-based mindfulness timer - [IMPLEMENTED]
- [x] Set meditation length (timer)
- [x] Pick sound (wish: Spotify integration)
- [ ] Toggle sound ease in & ease out volumes

### Mindful moments (reminders) - [PARTIALLY IMPLEMENTED]
- [x] Pick number & time(s) of reminder(s): 1, 2 or 3 (Current implementation allows custom max bells)
- [ ] Select frequency of reminders (daily, weekly)
  - [x] Create custom reminder
  - [x] Update reminder
  - [ ] Delete reminder

### Social mindfulness (shared moments) - [NOT IMPLEMENTED]
Simultaneous mindful moments with family and friends: regardless of your location, you can share a moment of calm
- [ ] This is a share & accept feature

### Settings - [IMPLEMENTED]
- [x] Toggle dark/light mode
- [x] Set Max Bells limit
- [x] Toggle Angel Numbers visibility
- [x] About page with external link

## Additional Implemented Features

### Authentication & Onboarding - [IMPLEMENTED]
- [x] Splash screen
- [x] Secure phone number authentication using Firebase OTP

### Angel Numbers - [IMPLEMENTED]
- [x] Display and explain angel numbers for spiritual insight

### Home Interface - [IMPLEMENTED]
- [x] Carousel-based navigation (swiping between Mindful Bells and Meditation Timer)

## UX Goals & Streamlined User Flows

To maintain a frictionless and serene experience, actions within the app are designed to be completed in 3 steps or less, utilizing smart defaults, gesture navigation, and one-tap actions.

### 1. Authentication & Onboarding
- **Step 1:** Open app to a serene splash screen and enter phone number.
- **Step 2:** Enter the OTP sent to your device.
- **Step 3:** Land instantly on the peaceful Home Carousel.

### 2. Sound-Based Mindfulness Timer
- **Step 1:** Swipe to the Meditation Timer screen.
- **Step 2:** Tap a pre-set duration pill (e.g., "10 min").
- **Step 3:** Tap Start (or wait 3 seconds to auto-start).

### 3. Mindful Moments (Reminders / Bells)
- **Step 1:** Swipe to the Mindful Bells screen.
- **Step 2:** Tap an empty time slot or the "+" icon.
- **Step 3:** Scroll to desired time and tap outside the picker to auto-save.

### 4. Social Mindfulness (Shared Moments)
- **Step 1:** From an active/scheduled Bell, tap the Share icon.
- **Step 2:** Select a contact from the quick-select list.
- **Step 3:** Tap Send Invite.

### 5. Angel Numbers
- **Step 1:** Tap the gentle glowing indicator when an Angel Number appears.
- **Step 2:** Read the brief, soothing insight.
- **Step 3:** Swipe down to dismiss and return to the main screen.

### 6. Settings
- **Step 1:** Tap the minimal gear/profile icon on the Home Carousel.
- **Step 2:** Toggle desired preferences (e.g., Dark Mode).
- **Step 3:** Swipe down to auto-save and return.
