# TriBhasha Flashcards

A Flutter/Dart mobile app for learning **Malayalam, Kannada, and English**
side by side through flashcards and active-recall quizzes.

## 1. Name of the App
**TriBhasha** ("tri-language") Flashcards

## 2. Objective
Help learners build vocabulary across Malayalam, Kannada, and English at
the same time by pairing every word/phrase with all three translations on
one card, and reinforcing memory through a self-scored quiz mode
(active recall + spaced repetition style accuracy tracking).

## 3. Features
- **10+ widgets used:** `Scaffold`, `AppBar`, `Drawer`, `ListView`,
  `GridView.count`, `Card`, `TextFormField`, `DropdownButtonFormField`,
  `ElevatedButton`, `OutlinedButton`, `FloatingActionButton`, `Dismissible`,
  `AlertDialog`, `CircularProgressIndicator`, `LinearProgressIndicator`,
  `Icon`, `CircleAvatar`, custom `FlipCard` (Transform/AnimationController).
- **Home screen with Drawer widget:** navigation to All Flashcards,
  Favorites, Quiz Mode, and Settings.
- **5 screens:** Home, Flashcard List, Add/Edit, Quiz, Settings.
- **User input screen:** Add/Edit Flashcard form (English, Malayalam,
  Kannada text fields + category dropdown, with validation).
- **Navigation:** `Navigator.push`/`pop` between all screens, Drawer-based
  navigation, category tiles on Home routing into filtered lists.
- **Add / Edit / Delete content:** full CRUD on flashcards, persisted
  locally with `shared_preferences` so data survives app restarts.
- **External service integration (optional):** on-device text-to-speech
  pronunciation of the Malayalam/Kannada text via the `flutter_tts` package.

## 4. Design
- **Color scheme:** deep teal `#00695C` primary (calm, focused study feel)
  with warm amber `#FFA000` as the secondary/accent color (warmth, "correct
  answer" highlight). Background `#FAFAF7` off-white.
- **Typography:** Material 3 default (Roboto) for Latin script; the
  platform's built-in Noto fallback fonts render Malayalam and Kannada
  glyphs automatically on both Android and iOS — no extra font bundling
  required.
- **Reference elements:** rounded 16px card corners, soft elevation,
  a 3D flip-card animation on the Quiz screen (front = English prompt,
  back = translations), category icon tiles on the dashboard.

## 5. Platform
Cross-platform via Flutter — runs on **Android and iOS** from a single
codebase. Minimum recommended SDKs: Android API 21+, iOS 12+.

## 6. Gaming
Not a gaming app — a study/reference tool with a quiz-style practice mode.

---

## Project Structure
```
lib/
  main.dart                    # App entry point, theme, root widget
  models/
    flashcard.dart             # Flashcard data model + JSON (de)serialization
  data/
    sample_data.dart           # Seed flashcards + category list
    flashcard_store.dart       # App state (ChangeNotifier) + persistence
  screens/
    home_screen.dart           # Dashboard + Drawer navigation
    flashcard_list_screen.dart # Browse / search / delete / favorite
    add_edit_screen.dart       # Create / edit form
    quiz_screen.dart           # Flip-card practice mode + TTS
    settings_screen.dart       # About + reset progress
  widgets/
    flip_card.dart             # Reusable 3D flip animation widget
```

## Getting Started

1. Install the [Flutter SDK](https://docs.flutter.dev/get-started/install)
   (stable channel, Dart 3+).
2. From the project root:
   ```bash
   flutter pub get
   flutter run
   ```
3. To build release binaries:
   ```bash
   flutter build apk        # Android
   flutter build ios        # iOS (requires macOS + Xcode)
   ```

## Notes
- Data is stored locally on-device with `shared_preferences` (JSON-encoded)
  — no backend/server required.
- `flutter_tts` needs an internet connection or installed voice packs on
  some devices for non-English languages; it degrades gracefully (button
  simply won't produce audio) if unsupported.
- To add more starter vocabulary, edit `lib/data/sample_data.dart`.
