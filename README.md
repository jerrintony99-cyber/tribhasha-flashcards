# TriBhasha Flashcards

A Flutter/Dart mobile app for learning **Malayalam, Kannada, and English** side by side through flashcards and active-recall quizzes.

![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS-blue)
![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)
![License](https://img.shields.io/badge/license-Educational-lightgrey)

---

## Overview

| | |
|---|---|
| **App name** | TriBhasha ("tri-language") Flashcards |
| **Type** | Study / reference tool with a quiz-style practice mode (not a game) |
| **Platform** | Cross-platform via Flutter — Android (API 21+) and iOS (12+) from one codebase |
| **Persistence** | 100% on-device via `shared_preferences` (JSON) — no backend/server required |

## Objective

Help learners build vocabulary across Malayalam, Kannada, and English at the same time by pairing every word or phrase with all three translations on one card, and reinforce memory through a self-scored quiz mode (active recall + spaced-repetition-style accuracy tracking).

## Features

- **5 screens:** Home, Flashcard List, Add/Edit, Quiz, Settings
- **Home dashboard with Drawer navigation** — stats card (words / accuracy / favourites), category grid, and quick-start quiz button
- **Full CRUD** on flashcards — add, edit, delete, and favourite words, persisted locally so data survives app restarts
- **Search & filter** — live search across all three languages, browse by category or favourites-only
- **Quiz / active-recall mode** — a custom 3D `FlipCard` animation (front = English prompt, back = Malayalam + Kannada translations), self-marked "Got it" / "Missed it" scoring that feeds per-card and overall accuracy stats
- **Text-to-speech pronunciation** of Malayalam/Kannada translations via `flutter_tts` (degrades gracefully if unsupported on a device)
- **Validated input form** — Add/Edit screen with required English/Malayalam/Kannada fields and a category dropdown
- **Settings screen** — reset review/accuracy stats without losing your flashcards

**10+ Material widgets used:** `Scaffold`, `AppBar`, `Drawer`, `ListView`, `GridView.count`, `Card`, `TextFormField`, `DropdownButtonFormField`, `ElevatedButton`, `OutlinedButton`, `FloatingActionButton`, `Dismissible`, `AlertDialog`, `CircularProgressIndicator`, `LinearProgressIndicator`, `Icon`, `CircleAvatar`, plus the custom `FlipCard` (`Transform` + `AnimationController`).

## Design

- **Colour scheme:** deep teal `#00695C` primary (calm, focused study feel) with warm amber `#FFA000` as the secondary/accent colour (warmth, "correct answer" highlight); off-white `#FAFAF7` background
- **Typography:** Material 3 default (Roboto) for Latin script; the platform's built-in Noto fallback fonts render Malayalam and Kannada glyphs automatically on both Android and iOS — no extra font bundling required
- **Reference elements:** rounded 16px card corners, soft elevation, a 3D flip-card animation on the Quiz screen, category icon tiles on the dashboard

## Project Structure

```
lib/
  main.dart                     # App entry point, theme, root widget
  models/
    flashcard.dart              # Flashcard data model + JSON (de)serialization
  data/
    sample_data.dart            # Seed flashcards (150 words) + category list
    flashcard_store.dart        # App state (ChangeNotifier) + persistence
  screens/
    home_screen.dart            # Dashboard + Drawer navigation
    flashcard_list_screen.dart  # Browse / search / delete / favorite
    add_edit_screen.dart        # Create / edit form
    quiz_screen.dart            # Flip-card practice mode + TTS
    settings_screen.dart        # About + reset progress
  widgets/
    flip_card.dart              # Reusable 3D flip animation widget
```

## Architecture

- **Model** — `Flashcard` holds `english`, `malayalam`, `kannada`, `category`, favourite flag, and review stats (`timesReviewed` / `timesCorrect`, used to compute `accuracy`).
- **State** — `FlashcardStore` (a `ChangeNotifier`) owns the single in-memory list of flashcards for the app's lifetime, exposes CRUD + favourite + review methods, and persists every change to `shared_preferences` as JSON.
- **View** — Every screen wraps its body in a `ListenableBuilder` listening to the same shared `FlashcardStore` instance (created once in `main.dart`), so all screens stay in sync automatically with no extra plumbing.

## Dependencies

| Package | Version | Purpose |
|---|---|---|
| `flutter` | SDK | Core framework, Material 3 widgets |
| `shared_preferences` | ^2.2.2 | Local JSON persistence of flashcards |
| `flutter_tts` | ^4.0.2 | On-device text-to-speech pronunciation |
| `cupertino_icons` | ^1.0.6 | iOS-style icon set |
| `flutter_lints` | ^3.0.0 (dev) | Static analysis / linting |

## Getting Started

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (stable channel, Dart 3+)
- Android Studio / Xcode (for device or emulator builds)

### Run locally
```bash
git clone <repo-url>
cd tribhasha_flashcards
flutter pub get
flutter run
```

### Build release binaries
```bash
flutter build apk        # Android
flutter build ios        # iOS (requires macOS + Xcode)
```

## Usage

1. Launch the app — the Home dashboard loads with 150 seeded words across 6 categories (Greetings, Food, Family, Numbers, Travel, Other).
2. Open the **Drawer** (top-left) to jump to All Flashcards, Favorites, Quiz Mode, or Settings.
3. Tap a **category tile** to browse just that set, or use the **search bar** on the list screen.
4. Tap **+** to add a new word (English, Malayalam, Kannada + category), or tap an existing card to edit it; swipe left to delete.
5. Tap **Start Quick Quiz** to practice — tap the card to flip and reveal the translations, listen to pronunciation with the speaker icon, then mark yourself "Got it" or "Missed it".
6. Check your **Accuracy** and **Words** stats on the Home dashboard, or reset progress from **Settings**.

## Notes

- Data is stored locally on-device with `shared_preferences` (JSON-encoded) — no backend/server required.
- `flutter_tts` needs an internet connection or installed voice packs on some devices for non-English languages; it degrades gracefully (the speaker button simply won't produce audio) if unsupported.
- To add more starter vocabulary, edit `lib/data/sample_data.dart`.

## Roadmap / Possible Enhancements

- Cloud sync across devices
- True spaced-repetition scheduling driven by the existing accuracy stats
- User-recorded audio for pronunciation practice
- Support for additional Indian languages

---

*Built as part of an Intra-Institutional Internship (INT410) — Mobile Application Development.*
