# Changelog

All notable changes to **N:OW** will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html)
automated via [Google Release Please](https://github.com/googleapis/release-please).

## [1.1.0](https://github.com/aycarl/NOW/compare/v1.0.0...v1.1.0) (2026-10-23)


### Features

* **sanctuary:** implement Breathing Orb, Whisper Capsule attunement sheet, and Mindful Bells UI ([e2476bb](https://github.com/aycarl/NOW/commit/e2476bbde1d34a9d71e641b3f48eb89212ba29e7))
* **tao:** implement 'Less is More' Tao Sanctuary UI/UX, Design System & SemVer CI/CD ([8c35a5a](https://github.com/aycarl/NOW/commit/8c35a5a9cd536de1b43ce997e70121091899c49d))
* **theme:** implement Yin & Yang TaoPalette theme system and ZenSoundSymbol painter ([98e029e](https://github.com/aycarl/NOW/commit/98e029e02bd365fb348dc749018585ce4fd4e57f))


### Bug Fixes

* **ios:** remove duplicate SPM FirebaseAuth linkage and set iOS 15.0 deployment target ([888eca3](https://github.com/aycarl/NOW/commit/888eca36649a3fbec4f6df34ed0c140d883fc63b))
* resolve UI overflow issues and update macOS deployment target to 12.0 ([06bb4c3](https://github.com/aycarl/NOW/commit/06bb4c39b24e87ff1fe345a7695f032090fec13e))


### Code Refactoring

* Convert CarouselHomePage to Stacked Cards UI and document Tao UI/UX concept ([4e3849c](https://github.com/aycarl/NOW/commit/4e3849c72e1a9315583915d31971c170cd7944f9))


### Documentation

* add feature list documentation detailing current implementation status ([99a90c1](https://github.com/aycarl/NOW/commit/99a90c1db785cfd4f5287d3a281b86c4cc20d192))
* add UX goals and streamlined user flow descriptions to feature list ([d67770b](https://github.com/aycarl/NOW/commit/d67770b207b77213174d2cfc7577f86ae9a0e4ca))
* modularize feature documentation by replacing the central feature list with a dedicated directory ([6f7a460](https://github.com/aycarl/NOW/commit/6f7a4604cf3761c6c1bda942e573e4826ccfa7d5))
* **tao:** document Less is More Tao UI/UX, standard design system, and AGENTS.md ([1bb1a47](https://github.com/aycarl/NOW/commit/1bb1a47e626664d1972d8f28afc469ea17957cd4))

## [1.0.0] - 2026-10-22

### Features
- Initial release of N:OW mindfulness companion (`MeditationTimerPage`, `MindfulBellsPage`, `CarouselHomePage`, and `SettingsPage`).
