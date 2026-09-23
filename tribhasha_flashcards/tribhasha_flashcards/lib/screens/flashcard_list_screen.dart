import 'package:flutter/material.dart';
import '../data/flashcard_store.dart';
import '../models/flashcard.dart';
import 'add_edit_screen.dart';

/// Lists flashcards, optionally filtered by category or favorites-only.
/// Supports live search, tapping to edit, swipe-to-delete, and a favorite
/// toggle icon on each row — this is the screen that satisfies the
/// "adding / editing / deleting content" requirement together with
/// AddEditScreen.
class FlashcardListScreen extends StatefulWidget {
  final FlashcardStore store;
  final String? filterCategory;
  final bool favoritesOnly;

  const FlashcardListScreen({
    super.key,
    required this.store,
    this.filterCategory,
    this.favoritesOnly = false,
  });

  @override
  State<FlashcardListScreen> createState() => _FlashcardListScreenState();
}

class _FlashcardListScreenState extends State<FlashcardListScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final title = widget.favoritesOnly
        ? 'Favorites'
        : (widget.filterCategory ?? 'All Flashcards');

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AddEditScreen(
              store: widget.store,
              defaultCategory: widget.filterCategory,
            ),
          ),
        ),
      ),
      body: ListenableBuilder(
        listenable: widget.store,
        builder: (context, _) {
          List<Flashcard> cards = widget.store.cards;
          if (widget.filterCategory != null) {
            cards = cards.where((c) => c.category == widget.filterCategory).toList();
          }
          if (widget.favoritesOnly) {
            cards = cards.where((c) => c.isFavorite).toList();
          }
          if (_query.isNotEmpty) {
            final q = _query.toLowerCase();
            cards = cards
                .where((c) =>
                    c.english.toLowerCase().contains(q) ||
                    c.malayalam.toLowerCase().contains(q) ||
                    c.kannada.toLowerCase().contains(q))
                .toList();
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Search words...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  onChanged: (v) => setState(() => _query = v),
                ),
              ),
              Expanded(
                child: cards.isEmpty
                    ? const Center(child: Text('No flashcards yet. Tap + to add one.'))
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80),
                        itemCount: cards.length,
                        itemBuilder: (context, index) {
                          final card = cards[index];
                          return Dismissible(
                            key: ValueKey(card.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.only(right: 20),
                              color: Colors.redAccent,
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (_) => _confirmDelete(context, card),
                            onDismissed: (_) => widget.store.delete(card.id),
                            child: Card(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              child: ListTile(
                                title: Text(card.english, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text('${card.malayalam}\n${card.kannada}'),
                                isThreeLine: true,
                                leading: CircleAvatar(child: Text(card.category[0])),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        card.isFavorite ? Icons.favorite : Icons.favorite_border,
                                        color: card.isFavorite ? Colors.redAccent : null,
                                      ),
                                      onPressed: () => widget.store.toggleFavorite(card.id),
                                    ),
                                  ],
                                ),
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => AddEditScreen(store: widget.store, existing: card),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<bool> _confirmDelete(BuildContext context, Flashcard card) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete flashcard?'),
        content: Text('Remove "${card.english}" permanently?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    return result ?? false;
  }
}
