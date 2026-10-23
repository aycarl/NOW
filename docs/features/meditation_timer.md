# Sound-based Mindfulness Timer (Meditation Sanctuary)

Status: [IMPLEMENTED]

- [x] Set meditation length (timer) via the progressive-disclosure Whisper Capsule & Frosted Attunement Sheet
- [x] Set settling preparation breath (`0s`–`60s`)
- [x] Pick sound resonance via minimalist Acoustic Sacred Symbols (`ZenSoundSymbol`)
- [x] Live breathing orb & countdown timer loop with dissolving UI chrome (`Inhale · Hold · Exhale`)
- [ ] Toggle sound ease in & ease out volumes (future enhancement)

## UI/UX Architecture ("Less is More")
The Meditation Timer embodies the Taoist principle of emptiness (*Kong*):
1. **Resting Sanctuary:** Displays 90% uncluttered stone-washed space with the central **Breathing Orb**, whispered `10:00` countdown digits, and a single **Whisper Capsule** (`◯ Singing Bowl · 10m · 10s prep`).
2. **Whisper Attunement Sheet:** Tapping the Whisper Capsule or duration digits opens a translucent frosted bottom sheet containing horizontal ribbons for **Duration**, **Preparation Breath**, and **Bell Resonance**.
3. **Active Countdown (Dissolving Chrome):** Tapping the Breathing Orb starts the countdown and smoothly fades out (`AnimatedOpacity`) the top icons, quote, Whisper Capsule, and bottom peeking tab so only the breathing orb and countdown remain.

## User Flow (3 Steps or Less)
- **Step 1:** Open the app (or tap the Whisper Capsule to adjust duration/sound in the frosted sheet).
- **Step 2:** Tap the central **Breathing Orb** to begin stillness immediately.
- **Step 3:** Breathe with the orb until the timer completes, or tap **End Stillness** to finish early.
