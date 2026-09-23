import 'package:flutter/material.dart';
import '../data/flashcard_store.dart';
import '../data/sample_data.dart';
import 'flashcard_list_screen.dart';
import 'quiz_screen.dart';
import 'add_edit_screen.dart';
import 'settings_screen.dart';

/// App landing screen. Contains the compulsory Drawer for navigation plus
/// a dashboard: progress summary, category grid, and quick-start quiz button.
class HomeScreen extends StatelessWidget {
  final FlashcardStore store;
  const HomeScreen({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tribhasha')),
      drawer: _AppDrawer(store: store),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Add Word'),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddEditScreen(store: store)),
        ),
      ),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          if (!store.loaded) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: store.load,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _StatsCard(store: store),
                const SizedBox(height: 20),
                Text('Practice by Category', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: categories.map((cat) {
                    final count = store.byCategory(cat).length;
                    return _CategoryTile(
                      category: cat,
                      count: count,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => FlashcardListScreen(store: store, filterCategory: cat),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  icon: const Icon(Icons.quiz),
                  label: const Text('Start Quick Quiz (All Words)'),
                  onPressed: store.totalCards == 0
                      ? null
                      : () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => QuizScreen(store: store)),
                          ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _AppDrawer extends StatelessWidget {
  final FlashcardStore store;
  const _AppDrawer({required this.store});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Icon(Icons.school, color: Colors.white, size: 36),
                SizedBox(height: 8),
                Text('TriBhasha', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
                Text('Malayalam · Kannada · English', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.style),
            title: const Text('All Flashcards'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => FlashcardListScreen(store: store)));
            },
          ),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text('Favorites'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => FlashcardListScreen(store: store, favoritesOnly: true)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.quiz),
            title: const Text('Quiz Mode'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => QuizScreen(store: store)));
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen(store: store)));
            },
          ),
        ],
      ),
    );
  }
}

class _StatsCard extends StatelessWidget {
  final FlashcardStore store;
  const _StatsCard({required this.store});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _StatItem(label: 'Words', value: '${store.totalCards}', icon: Icons.style),
            _StatItem(
              label: 'Accuracy',
              value: '${store.overallAccuracy.toStringAsFixed(0)}%',
              icon: Icons.trending_up,
            ),
            _StatItem(
              label: 'Favorites',
              value: '${store.cards.where((c) => c.isFavorite).length}',
              icon: Icons.favorite,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  const _StatItem({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary),
        const SizedBox(height: 6),
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  final String category;
  final int count;
  final VoidCallback onTap;
  const _CategoryTile({required this.category, required this.count, required this.onTap});

  static const Map<String, IconData> _icons = {
    'Greetings': Icons.waving_hand,
    'Food': Icons.restaurant,
    'Family': Icons.family_restroom,
    'Numbers': Icons.pin,
    'Travel': Icons.flight,
    'Other': Icons.more_horiz,
  };

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_icons[category] ?? Icons.category, size: 28, color: Theme.of(context).colorScheme.secondary),
              const SizedBox(height: 8),
              Text(category, style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('$count words', style: const TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}
