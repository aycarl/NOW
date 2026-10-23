# The Tao UI/UX Concept ("Less is More" Specification)

This document defines the structured UI/UX architecture for **N:OW**, inspired by the philosophy of the Tao (The Way) and benchmarked against leading minimalist mindfulness tools (**Ensō**, **Oak**, **Endel**, and **Waking Up**).

---

## Core Philosophy

To embody the essence of the Tao, the experience is grounded in three pillars:
1. **Emptiness (Space / *Kong*):** "The usefulness of a cup comes from its emptiness." Over 90% of the primary screen remains uncluttered negative space.
2. **Effortless Action (*Wu Wei*):** Zero unnecessary structural chrome. Controls appear only when needed and dissolve completely during meditation.
3. **Naturalness (*Ziran*) & Balance (*Yin / Yang*):** Organic motion (breathing cycles and harmonic ripples) paired with a dual palette of warm stone-washed paper (**Yang / Washi Light**) and moonlit charcoal (**Yin / Obsidian Night**).

---

## 1. The 90% Emptiness Rule & Dissolving Countdown Sanctuary

Instead of splitting the Meditation Timer into a cluttered "Setup Screen" and a separate "Timer Screen", the **Resting Home Screen** and the **Active Countdown Screen** share the exact same sanctuary layout:

* **Resting State (Idle):**
  * **Floating Top Chrome:** Minimalist, semi-transparent icons for Settings and Donations/Support (plus a subtle `✦ 11:11` indicator when Angel Numbers are enabled) float directly on the canvas with no rigid `AppBar`.
  * **Whispered Quote:** A single italicized contemplation floats above the orb. Tapping it cycles to a new reflection.
  * **The Breathing Orb:** A soft, luminous sphere in the center of the screen gently expands and contracts on an 8-second breathing rhythm.
  * **Whispered Time (`10:00`):** Thin, wide-tracked typography (`FontWeight.w200`) sits directly beneath the orb.
  * **The Whisper Capsule:** A single translucent pill (`◯ Singing Bowl · 10m · 10s prep`) consolidates all session parameters into one line.
* **Active Countdown State (Dissolving Chrome):**
  * Tapping the Breathing Orb starts the session (beginning with any configured preparation seconds, followed by the meditation countdown).
  * **All surrounding UI chrome dissolves (`AnimatedOpacity -> 0.0`):** The top icons, quote, Whisper Capsule, and bottom *Mindful Bells* peeking tab smoothly fade and slide away.
  * Only the pulsing **Breathing Orb** (with a subtle `Inhale · Hold · Exhale` cue), the live countdown digits, and a faint `End Stillness` button remain on screen.

---

## 2. Progressive Disclosure via the "Whisper Capsule"

To prevent the 3 configuration parameters (**Duration**, **Preparation Breath**, and **Bell Resonance**) from cluttering the home canvas:

* **Single Entry Point:** On the home screen, all three settings are summarized inside the **Whisper Capsule** (`◯ Singing Bowl · 10m · 10s prep`).
* **Frosted Attunement Sheet (`_SessionAttunementSheet`):** Tapping either the Whisper Capsule or the `10:00` digits raises a compact, translucent frosted-glass bottom sheet (`BackdropFilter` with `ImageFilter.blur`) containing three clean horizontal selectors:
  1. **Duration Ribbon:** Horizontal pill selector (`5m`, `10m`, `15m`, `20m`, `30m`, `45m`, `60m`).
  2. **Preparation Breath Ribbon:** Horizontal pill selector (`0s`, `10s`, `10s`, `20s`, `30s`, `60s`).
  3. **Bell Resonance Row:** Acoustic sacred geometry symbols representing each sound option.

---

## 3. Acoustic Sacred Symbols (`ZenSoundSymbol`)

Rather than generic Material icons or text-only dropdowns, each sound timbre is represented by a minimalist sacred geometry symbol rendered via custom vector strokes:

| Sound Key | Display Name | Sacred Symbol | Visual Meaning |
| :--- | :--- | :--- | :--- |
| `singing_bowl` | **Singing Bowl** | **Enso Circle (`◯`)** | Incomplete hand-drawn Zen circle representing resonance and emptiness |
| `default` / `gong` | **Temple Shō** | **Concentric Ripple (`◎`)** | Center point with radiating acoustic ring |
| `chime` | **Pin Chime** | **Dewdrop (`💧`)** | Crisp, single-point water droplet |
| `nature` / `white_noise` | **Bamboo Wind** | **Flowing Wave (`〰`)** | Dual organic sine waves representing wind and water |

---

## 4. Yin & Yang Dual Palette (`TaoPalette`)

Toggling **Dark Mode** in Settings transitions the entire application between two nature-inspired palettes without any hardcoded light colors:

| Semantic Token | Washi Light (Yang) | Obsidian Night (Yin / Dark Mode) |
| :--- | :--- | :--- |
| `scaffoldCanvas` | `#EBE7DF` (Warm Stone Washi Paper) | `#111312` (Deep Mineral Charcoal) |
| `peekingCardSurface` | `rgba(232, 227, 218, 0.86)` | `rgba(22, 25, 23, 0.90)` |
| `frostedSheetSurface` | `rgba(244, 241, 234, 0.95)` | `rgba(24, 26, 25, 0.96)` |
| `inkPrimary` | `#3A3832` (Sumi Ink Charcoal) | `#E5E0D5` (Moonlit Silk) |
| `inkMuted` | `#7A756C` (Weathered Stone) | `#8E8B82` (Misty Ash) |
| `accentPrimary` | `#5C6658` (Bamboo Sage) | `#D4AF73` (Warm Temple Amber) |
| `orbCore` → `orbEdge` | `#FFFFFF` → `#FBF3E4` → `#E5D4B7` | `#4A3E2D` → `#2B251D` → `#121312` |

---

## 5. Hairline Typography for Mindful Bells

* **Peeking Tab (Collapsed State):** When on the Meditation Timer, *Mindful Bells* peeks from the bottom 8% of the screen as a frosted glass bar with centered `MINDFUL BELLS` typography.
* **Expanded Sanctuary:** Swiping up (or tapping the peeking tab) reveals the scheduled daily moments as calm, borderless typographic rows separated by subtle hairlines (`Divider`), avoiding heavy Material cards.
* **Spontaneous Angel Numbers:** When enabled in Settings, an organic golden-stone whisper banner (`✦ Angel Numbers`) provides effortless access to Angel Number reflections.
