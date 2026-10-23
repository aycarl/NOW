# N:OW Design System & Brand Identity Specification

> *"Thirty spokes share the wheel's hub; it is the center hole that makes it useful. Therefore profit comes from what is there; usefulness comes from what is not there."*
> — **Tao Te Ching, Chapter 11**

This document is the canonical reference for **N:OW's Brand Identity, Color Codes, Typography, Sacred Iconography, and Motion Physics** across mobile (`iOS`, `Android`), desktop (`macOS`, `Windows`, `Linux`), web portals, and marketing collateral.

---

## 1. Core Brand Philosophy

1. **90% Emptiness (*Ma* / Negative Space)**
   - Every primary canvas reserves at least **85–90% unencumbered mineral space** so the user's nervous system settles immediately upon opening the app.
   - Surface hierarchy is communicated through **subtle luminance shifts, atmospheric gradients, and 1px hairline borders** rather than heavy drop shadows or saturated material cards.
2. **Effortless Action (*Wu Wei*)**
   - The **Resting Home Sanctuary** and the **Active Meditation Countdown** are the exact same physical space. Tapping the central **Breathing Orb** initiates stillness in-place while surrounding chrome dissolves (`opacity -> 0.0`).
3. **Progressive Disclosure (*Kanso* / Whisper Capsule)**
   - Secondary session parameters (Duration, Preparation Breath, Bell Resonance) are tucked into a single pill—the **Whisper Capsule**—and revealed on demand via a translucent frosted-glass bottom sheet.

---

## 2. The Yin & Yang Color System

N:OW uses a dual-polarity color system implemented in [`lib/core/theme/tao_theme.dart`](../lib/core/theme/tao_theme.dart) via the `TaoPalette` `ThemeExtension`. Pure `#FFFFFF` and `#000000` are intentionally avoided to eliminate harsh retinal contrast.

### 2.1 Yang Palette — *Washi Light Mode* (Daytime Sanctuary)
Inspired by unbleached Japanese *Washi* handmade paper, river stone, sun-warmed clay, and bamboo sage.

| Semantic Token | Role / Usage | Hex Code | RGB | HSL | Flutter Color Literal |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `scaffoldCanvas` | Primary Washi Stone Paper background | `#EBE7DF` | `rgb(235, 231, 223)` | `hsl(40°, 23%, 90%)` | `Color(0xFFEBE7DF)` |
| `stoneWashStart` | Upper-left atmospheric canvas wash | `#F3EFE8` | `rgb(243, 239, 232)` | `hsl(38°, 30%, 93%)` | `Color(0xFFF3EFE8)` |
| `stoneWashEnd` | Lower-right warm mineral clay wash | `#E1DDD3` | `rgb(225, 221, 211)` | `hsl(43°, 18%, 85%)` | `Color(0xFFE1DDD3)` |
| `peekingCardSurface` | Frosted bottom/top peeking card & sheet (`88%` alpha) | `#E0E5E0D7` | `rgba(229, 224, 215, 0.88)` | `hsla(39°, 21%, 87%, 0.88)` | `Color(0xE0E5E0D7)` |
| `peekingCardBorder` | Top/bottom card hairline border | `#D2CCC0` | `rgb(210, 204, 192)` | `hsl(40°, 16%, 79%)` | `Color(0xFFD2CCC0)` |
| `inkPrimary` | Deep Sumi Charcoal primary text & digits | `#2C2E2B` | `rgb(44, 46, 43)` | `hsl(100°, 3%, 17%)` | `Color(0xFF2C2E2B)` |
| `inkSecondary` | Weathered Slate secondary body copy | `#5A5D57` | `rgb(90, 93, 87)` | `hsl(90°, 3%, 35%)` | `Color(0xFF5A5D57)` |
| `inkMuted` | Whispered captions, inactive icons, quotes | `#7A7D76` | `rgb(122, 125, 118)` | `hsl(86°, 3%, 48%)` | `Color(0xFF7A7D76)` |
| `accentPrimary` | Bamboo Sage active pill fill & primary action | `#5C6658` | `rgb(92, 102, 88)` | `hsl(103°, 7%, 37%)` | `Color(0xFF5C6658)` |
| `accentOnPrimary` | Warm Ivory text/icon on Bamboo Sage | `#F6F4EF` | `rgb(246, 244, 239)` | `hsl(43°, 30%, 95%)` | `Color(0xFFF6F4EF)` |
| `accentGold` | Warm Ochre highlight border & sacred accent | `#B59461` | `rgb(181, 148, 97)` | `hsl(36°, 37%, 55%)` | `Color(0xFFB59461)` |
| `orbGradient[0]` | Breathing Orb inner core highlight | `#FFFFFF` | `rgb(255, 255, 255)` | `hsl(0°, 0%, 100%)` | `Color(0xFFFFFFFF)` |
| `orbGradient[1]` | Breathing Orb mid-tone warm cream | `#F4EFE4` | `rgb(244, 239, 228)` | `hsl(41°, 38%, 93%)` | `Color(0xFFF4EFE4)` |
| `orbGradient[2]` | Breathing Orb outer mineral rim | `#E5DCCB` | `rgb(229, 220, 203)` | `hsl(39°, 31%, 85%)` | `Color(0xFFE5DCCB)` |
| `orbGlow` | Diffuse radial halo around Breathing Orb | `#59D9CCAE` | `rgba(217, 204, 174, 0.35)` | `hsla(42°, 36%, 77%, 0.35)` | `Color(0x59D9CCAE)` |
| `capsuleSurface` | Whisper Capsule & chip resting fill | `#B3DFDAD0` | `rgba(223, 218, 208, 0.70)` | `hsla(40°, 19%, 85%, 0.70)` | `Color(0xB3DFDAD0)` |
| `capsuleBorder` | Whisper Capsule & chip resting stroke | `#CFC9BD` | `rgb(207, 201, 189)` | `hsl(40°, 16%, 78%)` | `Color(0xFFCFC9BD)` |
| `hairlineDivider` | 1px list item separator | `#D9D4C9` | `rgb(217, 212, 201)` | `hsl(41°, 17%, 82%)` | `Color(0xFFD9D4C9)` |

---

### 2.2 Yin Palette — *Obsidian Night Mode* (Nocturnal Sanctuary)
Inspired by temple incense ash, midnight slate, and warm candlelight bronze. Designed to preserve melatonin production during evening and night meditation.

| Semantic Token | Role / Usage | Hex Code | RGB | HSL | Flutter Color Literal |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `scaffoldCanvas` | Deep Obsidian Mineral Charcoal background | `#111312` | `rgb(17, 19, 18)` | `hsl(150°, 6%, 7%)` | `Color(0xFF111312)` |
| `stoneWashStart` | Upper-left nocturnal slate wash | `#161917` | `rgb(22, 25, 23)` | `hsl(140°, 6%, 9%)` | `Color(0xFF161917)` |
| `stoneWashEnd` | Lower-right deep obsidian shadow | `#0C0E0D` | `rgb(12, 14, 13)` | `hsl(150°, 8%, 5%)` | `Color(0xFF0C0E0D)` |
| `peekingCardSurface` | Frosted nocturnal card & sheet (`91%` alpha) | `#E81A1D1B` | `rgba(26, 29, 27, 0.91)` | `hsla(140°, 5%, 11%, 0.91)` | `Color(0xE81A1D1B)` |
| `peekingCardBorder` | Nocturnal card hairline border | `#2A2E2B` | `rgb(42, 46, 43)` | `hsl(135°, 4%, 17%)` | `Color(0xFF2A2E2B)` |
| `inkPrimary` | Moonlit Silk Parchment primary text & digits | `#E6E2D8` | `rgb(230, 226, 216)` | `hsl(43°, 23%, 87%)` | `Color(0xFFE6E2D8)` |
| `inkSecondary` | Muted Silver Ash secondary copy | `#A8A49B` | `rgb(168, 164, 155)` | `hsl(42°, 6%, 63%)` | `Color(0xFFA8A49B)` |
| `inkMuted` | Dimmed Incense Smoke captions & icons | `#87837A` | `rgb(135, 131, 122)` | `hsl(42°, 5%, 50%)` | `Color(0xFF87837A)` |
| `accentPrimary` | Warm Candlelight Bronze active pill fill | `#332B21` | `rgb(51, 43, 33)` | `hsl(33°, 21%, 16%)` | `Color(0xFF332B21)` |
| `accentOnPrimary` | Luminous Amber Gold text/icon on active pill | `#E2C289` | `rgb(226, 194, 137)` | `hsl(38°, 60%, 71%)` | `Color(0xFFE2C289)` |
| `accentGold` | Temple Gold highlight border & sacred accent | `#D4AF73` | `rgb(212, 175, 115)` | `hsl(37°, 53%, 64%)` | `Color(0xFFD4AF73)` |
| `orbGradient[0]` | Breathing Orb inner warm ember core | `#433829` | `rgb(67, 56, 41)` | `hsl(35°, 24%, 21%)` | `Color(0xFF433829)` |
| `orbGradient[1]` | Breathing Orb mid-tone bronze | `#25211B` | `rgb(37, 33, 27)` | `hsl(36°, 16%, 13%)` | `Color(0xFF25211B)` |
| `orbGradient[2]` | Breathing Orb outer charcoal rim | `#171917` | `rgb(23, 25, 23)` | `hsl(120°, 4%, 9%)` | `Color(0xFF171917)` |
| `orbGlow` | Diffuse amber halo around Breathing Orb | `#45D4AF73` | `rgba(212, 175, 115, 0.27)` | `hsla(37°, 53%, 64%, 0.27)` | `Color(0x45D4AF73)` |
| `capsuleSurface` | Whisper Capsule & chip resting fill | `#CC1D201E` | `rgba(29, 32, 30, 0.80)` | `hsla(140°, 5%, 12%, 0.80)` | `Color(0xCC1D201E)` |
| `capsuleBorder` | Whisper Capsule & chip resting stroke | `#2F3330` | `rgb(47, 51, 48)` | `hsl(135°, 4%, 19%)` | `Color(0xFF2F3330)` |
| `hairlineDivider` | 1px nocturnal list item separator | `#242825` | `rgb(36, 40, 37)` | `hsl(135°, 5%, 15%)` | `Color(0xFF242825)` |

---

## 3. Typography & Hierarchy System

N:OW pairs **ultra-light geometric numerals** with **wide-tracked uppercase micro-labels** and **italic contemplation quotes**.

| Element | Font Size | Weight | Letter Spacing | Style / Notes |
| :--- | :--- | :--- | :--- | :--- |
| **Brand Wordmark (`N:OW`)** | `15px` | `w300` (Light) | `6.0px` | Uppercase, left-aligned in transparent top bar |
| **Countdown Numerals (`10:00`)** | `48px` (`36px` compact) | `w200` (ExtraLight) | `4.5px` | Center-aligned below Breathing Orb |
| **Mindful Bell Time (`07:00 AM`)** | `22px` | `w300` (Light) | `1.2px` | Primary row anchor in `MindfulBellsPage` |
| **Sanctuary Section Title** | `22px` | `w700` (Bold) | `0.8px` | Used for `Mindful Bells` expanded header |
| **Contemplation Quote** | `15px` (`13px` compact) | `w300` (Light) | `0.2px` | `FontStyle.italic`, line-height `1.45`, max 2 lines |
| **Peeking Card Title** | `13px` | `w400` (Regular) | `2.4px` | Centered in `76px` peeking bottom/top card |
| **Breathing Cue (`INHALE` / `EXHALE`)** | `12px` | `w300` (Light) | `3.0px` | Uppercase inside Breathing Orb (`0.65` opacity) |
| **Sheet Section Header (`DURATION`)** | `12px` | `w400` (Regular) | `1.6px` | Uppercase, paired with right-aligned value label |
| **Whisper Capsule Summary** | `12px` | `w300` (Light) | `0.8px` | `◯ Singing Bowl · 10m · 10s prep` |

---

## 4. Sacred Geometry Acoustic Iconography (`ZenSoundSymbol`)

Instead of generic speaker or alarm icons, N:OW represents each acoustic bell resonance with a sacred geometric vector symbol rendered by [`ZenSoundSymbol`](../lib/core/widgets/zen_sound_symbol.dart) (`strokeWidth = size * 0.085`, `StrokeCap.round`):

| Sound Key (`value`) | Display Label | Sacred Symbol | Geometric Construction |
| :--- | :--- | :--- | :--- |
| `singing_bowl` | **Singing Bowl** (`Bowl`) | **Enso Circle** (`◯`) | Hand-brushed open Zen circle (`305°` arc starting at `-0.65 rad`) symbolizing emptiness and completion. |
| `default` / `gong` / `alarm` | **Temple Shō** (`Shō`) | **Concentric Ripple** (`◎`) | Outer ring (`r = 0.42`) with a centered strike point (`r = 0.10`) representing outward acoustic resonance. |
| `chime` | **Pin Chime** (`Chime`) | **Dewdrop** (`💧`) | Cubic Bézier water droplet (`top = 0.12`, `bottom = 0.88`) representing a clear, high-frequency strike. |
| `nature` | **Bamboo Wind** (`Wind`) | **Flowing Wave** (`≈`) | Dual parallel sinusoidal curves (`y = 0.38` and `y = 0.62`) representing wind through bamboo groves. |

---

## 5. Spatial Architecture, Glassmorphism & Motion Physics

1. **Stacked Cards Peeking Viewport (`76px`)**:
   - The inactive card (`MindfulBellsPage` when on Timer, or `MeditationTimerPage` when on Bells) peeks by exactly `76px` (`_peekingBarHeight = 76.0`) with a `28px` top corner radius and `ImageFilter.blur(sigmaX: 20, sigmaY: 20)`.
   - Card transitions use `Duration(milliseconds: 520)` with `Cubic(0.22, 1.0, 0.36, 1.0)` (gentle deceleration).
2. **Breathing Orb Sinusoidal Cycle (`4000ms`)**:
   - Driven by an `AnimationController(duration: Duration(milliseconds: 4000))` oscillating smoothly with `Curves.easeInOut`:
     - Inner sphere scales between `0.91` and `1.07` (`184px` base diameter).
     - Outer diffuse halo scales between `0.85` and `1.17` (`236px` base diameter) with alpha pulsing from `0.25` to `0.60`.
3. **Dissolving Chrome Transition (`450–500ms`)**:
   - When `_isSessionActive` transitions to `true`, the top `AppBar`, contemplation quote, Whisper Capsule, and bottom peeking card fade to `opacity: 0.0` (`IgnorePointer(ignoring: true)`), leaving 90%+ of the viewport empty.
