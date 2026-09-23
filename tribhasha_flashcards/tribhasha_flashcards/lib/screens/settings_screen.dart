import 'package:flutter/material.dart';
import '../data/flashcard_store.dart';

/// Simple settings / about screen. Shows app info and a reset option.
class SettingsScreen extends StatelessWidget {
  final FlashcardStore store;
  const SettingsScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('About TriBhasha'),
            subtitle: Text('A flashcard app for learning Malayalam, Kannada and English side by side.'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.redAccent),
            title: const Text('Clear all progress stats'),
            subtitle: const Text('Resets review counts and accuracy, keeps your words.'),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Reset progress?'),
                  content: const Text('This clears review history but keeps all flashcards.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Reset')),
                  ],
                ),
              );
              if (confirm == true) {
                await store.resetStats();
              }
            },
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.smartphone),
            title: Text('Platform'),
            subtitle: Text('Built with Flutter — runs on Android & iOS from one codebase.'),
          ),
          const ListTile(
            leading: Icon(Icons.palette_outlined),
            title: Text('Design'),
            subtitle: Text('Deep teal + warm amber theme, rounded cards, Material 3.'),
          ),
        ],
      ),
    );
  }
}
