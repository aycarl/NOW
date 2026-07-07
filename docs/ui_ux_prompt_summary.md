# Project Prompt: N:OW — A Minimalist Mindfulness App

### 1. The Core Philosophy
**Name:** N:OW  
**Slogan:** "Sharing mindful moments"  
**Ethos:** A "low-friction" utility app designed to reduce anxiety, not increase it. The UI should feel airy, intentional, and calm. It avoids "doom-scrolling" by using a constrained vertical carousel that focuses the user on one task at a time.

### 2. The Navigation Architecture (The "Vertical Stack")
*   **The Carousel:** A `PageView` with `Axis.vertical` and a `viewportFraction` of `0.92`.
*   **Behavior:** Users "slide" vertically between two primary states: **Meditation** (Top) and **Mindful Bells** (Bottom). 
*   **Partial Visibility:** The "inactive" page should always be slightly visible at the edge of the screen, acting as a gentle anchor to the other feature.

### 3. Feature Breakdown & UI Requirements

#### A. Meditation Timer (The "Stillness" Screen)
*   **Visual Focus:** A central, prominent countdown or "Time Remaining" indicator.
*   **Controls:** 
    *   **Duration Picker:** Needs a "Zen" wheel or slider (5–60 mins).
    *   **Soundscapes:** A selection of minimalist options (Singing Bowl, Nature, White Noise).
    *   **Preparation Phase:** A "count-in" period (10–60s) to allow the user to settle.
*   **Atmosphere:** While the timer is active, the UI should fade out non-essential elements (like the app bar) to minimize distraction.

#### B. Mindful Bells (The "Gentle Reminder" Screen)
*   **List View:** A vertical list of scheduled "bells" (reminders).
*   **Card Design:** Each bell is housed in a `Material 3` Card.
*   **Attributes:** Time (e.g., 07:00 AM), custom Label (e.g., "Deep Breath"), and Sound type.
*   **Constraints:** A global setting limits the maximum number of bells (e.g., 10) to prevent notification fatigue.

#### C. Angel Numbers (The "Synchronicity" Integration)
*   **Feature:** A toggleable card that appears only when enabled in settings.
*   **Design:** Mystical but minimalist. Use light gradients or subtle glows to distinguish it from standard notification cards.

### 4. Visual Language & Theming
*   **Primary Color:** `Deep Purple` (Seed: `#6750A4`).
*   **Theme Variations:**
    *   **Light Mode:** Off-white backgrounds (`#FAF9F6`), soft lavender accents, and high legibility.
    *   **Dark Mode:** Deep charcoal/midnight backgrounds (`#121212`), avoided pure blacks to reduce eye strain.
*   **Shapes:** High border radii (`16dp` to `24dp`) for all containers and buttons to maintain a "soft" feel.
*   **Typography:** Clean, modern Sans-Serif. Headlines should be bold but airy; quotes should be italicized and centered.

### 5. Interaction & Micro-animations
*   **Breathing Animation:** A subtle "pulsing" effect on the background or a circular element during meditation.
*   **Transitions:** Smooth, ease-in-out curves for the vertical page transitions.
*   **Success States:** Soft haptic feedback and gentle visual "shimmer" when a meditation session completes.

### 6. Technical Context (For Implementation)
*   **Framework:** Flutter (Material 3).
*   **State Management:** Provider.
*   **Persistence:** SharedPreferences (for theme and settings).
*   **Auth:** Firebase Phone/OTP (minimalist onboarding).
