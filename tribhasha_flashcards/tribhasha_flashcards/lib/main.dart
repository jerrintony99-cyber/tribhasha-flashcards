import 'package:flutter/material.dart';
import 'data/flashcard_store.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const TriBhashaApp());
}

/// Root widget. Owns the single FlashcardStore instance for the whole app
/// lifetime and loads persisted data before showing the Home screen.
class TriBhashaApp extends StatefulWidget {
  const TriBhashaApp({super.key});

  @override
  State<TriBhashaApp> createState() => _TriBhashaAppState();
}

class _TriBhashaAppState extends State<TriBhashaApp> {
  final FlashcardStore store = FlashcardStore();

  @override
  void initState() {
    super.initState();
    store.load();
  }

  @override
  Widget build(BuildContext context) {
    // Design language:
    //  - Primary: deep teal (#00695C) — calm, focused study feel
    //  - Secondary: warm amber (#FFA000) — warmth, energy, "correct answer" accent
    //  - Surface: soft off-white (#FAFAF7)
    //  - Typography: Roboto (system) for Latin text; the platform's Noto
    //    fallback fonts render the Malayalam and Kannada glyphs automatically.
    const seed = Color(0xFF00695C);
    return MaterialApp(
      title: 'TriBhasha Flashcards',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: seed,
          secondary: const Color(0xFFFFA000),
        ),
        scaffoldBackgroundColor: const Color(0xFFFAFAF7),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold),
          titleMedium: TextStyle(fontWeight: FontWeight.w600),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 22),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: HomeScreen(store: store),
    );
  }
}
