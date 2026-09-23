import 'package:flutter/material.dart';
import '../data/flashcard_store.dart';
import '../data/sample_data.dart';
import '../models/flashcard.dart';

/// Form screen for creating a new flashcard, or editing an existing one
/// when [existing] is passed in. This is the required "screen that must
/// contain input from the user".
class AddEditScreen extends StatefulWidget {
  final FlashcardStore store;
  final Flashcard? existing;
  final String? defaultCategory;

  const AddEditScreen({super.key, required this.store, this.existing, this.defaultCategory});

  @override
  State<AddEditScreen> createState() => _AddEditScreenState();
}

class _AddEditScreenState extends State<AddEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _englishCtrl;
  late final TextEditingController _malayalamCtrl;
  late final TextEditingController _kannadaCtrl;
  late String _category;

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    _englishCtrl = TextEditingController(text: e?.english ?? '');
    _malayalamCtrl = TextEditingController(text: e?.malayalam ?? '');
    _kannadaCtrl = TextEditingController(text: e?.kannada ?? '');
    _category = e?.category ?? widget.defaultCategory ?? categories.first;
  }

  @override
  void dispose() {
    _englishCtrl.dispose();
    _malayalamCtrl.dispose();
    _kannadaCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.existing != null) {
      final updated = widget.existing!
        ..english = _englishCtrl.text.trim()
        ..malayalam = _malayalamCtrl.text.trim()
        ..kannada = _kannadaCtrl.text.trim()
        ..category = _category;
      await widget.store.update(updated);
    } else {
      final newCard = Flashcard(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        english: _englishCtrl.text.trim(),
        malayalam: _malayalamCtrl.text.trim(),
        kannada: _kannadaCtrl.text.trim(),
        category: _category,
      );
      await widget.store.add(newCard);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Flashcard' : 'Add Flashcard')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _englishCtrl,
              decoration: const InputDecoration(labelText: 'English', border: OutlineInputBorder()),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _malayalamCtrl,
              decoration: const InputDecoration(labelText: 'Malayalam', border: OutlineInputBorder()),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _kannadaCtrl,
              decoration: const InputDecoration(labelText: 'Kannada', border: OutlineInputBorder()),
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _category,
              decoration: const InputDecoration(labelText: 'Category', border: OutlineInputBorder()),
              items: categories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
              onChanged: (v) => setState(() => _category = v!),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              icon: Icon(isEditing ? Icons.save : Icons.add),
              label: Text(isEditing ? 'Save Changes' : 'Add Flashcard'),
              onPressed: _save,
            ),
            if (isEditing) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                label: const Text('Delete', style: TextStyle(color: Colors.redAccent)),
                onPressed: () async {
                  await widget.store.delete(widget.existing!.id);
                  if (mounted) Navigator.pop(context);
                },
              ),
            ],
          ],
        ),
      ),
    );
  }
}
