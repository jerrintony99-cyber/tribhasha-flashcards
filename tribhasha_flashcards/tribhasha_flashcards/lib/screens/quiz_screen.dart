import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../data/flashcard_store.dart';
import '../models/flashcard.dart';
import '../widgets/flip_card.dart';

/// Practice / quiz mode: shows one flashcard at a time (English on front).
/// The user tries to recall the Malayalam & Kannada translations, taps the
/// card to flip and reveal the answer, then self-marks "Got it" / "Missed
/// it" — this feeds the accuracy stats shown on the Home screen and is the
/// main driver of "effective learning" (active recall practice).
///
/// Also integrates the optional external service mentioned in the spec
/// (item 3g): text-to-speech pronunciation via the flutter_tts package.
class QuizScreen extends StatefulWidget {
  final FlashcardStore store;
  final String? filterCategory;

  const QuizScreen({super.key, required this.store, this.filterCategory});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  late List<Flashcard> _deck;
  int _index = 0;
  bool _showBack = false;
  int _correct = 0;
  int _total = 0;
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _deck = widget.filterCategory == null
        ? List.of(widget.store.cards)
        : widget.store.byCategory(widget.filterCategory!);
    _deck.shuffle();
  }

  @override
  void dispose() {
    _tts.stop();
    super.dispose();
  }

  Future<void> _speak(String text) async {
    // Strips the romanised part in parentheses so TTS reads the script only.
    final clean = text.replaceAll(RegExp(r'\(.*?\)'), '').trim();
    await _tts.setLanguage('en-IN');
    await _tts.speak(clean.isEmpty ? text : clean);
  }

  void _mark(bool correct) {
    final card = _deck[_index];
    widget.store.recordReview(card.id, correct);
    setState(() {
      _total += 1;
      if (correct) _correct += 1;
      _showBack = false;
      if (_index < _deck.length - 1) {
        _index += 1;
      } else {
        _showSummary();
      }
    });
  }

  void _showSummary() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Session Complete 🎉'),
        content: Text('You scored $_correct / $_total correct.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_deck.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Quiz')),
        body: const Center(child: Text('No flashcards to practice in this set.')),
      );
    }
    final card = _deck[_index];
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz  (${_index + 1}/${_deck.length})'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            LinearProgressIndicator(value: (_index) / _deck.length),
            const SizedBox(height: 24),
            Expanded(
              child: Center(
                child: FlipCard(
                  showBack: _showBack,
                  onTap: () => setState(() => _showBack = !_showBack),
                  front: _CardFace(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('English', style: TextStyle(fontSize: 14, color: Colors.black54)),
                        const SizedBox(height: 12),
                        Text(card.english,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        const Text('Tap to reveal translations', style: TextStyle(color: Colors.black45)),
                      ],
                    ),
                  ),
                  back: _CardFace(
                    color: Theme.of(context).colorScheme.secondaryContainer,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _TranslationRow(label: 'Malayalam', text: card.malayalam, onSpeak: () => _speak(card.malayalam)),
                        const SizedBox(height: 16),
                        _TranslationRow(label: 'Kannada', text: card.kannada, onSpeak: () => _speak(card.kannada)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_showBack)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      icon: const Icon(Icons.close, color: Colors.redAccent),
                      label: const Text('Missed it', style: TextStyle(color: Colors.redAccent)),
                      onPressed: () => _mark(false),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.check),
                      label: const Text('Got it'),
                      onPressed: () => _mark(true),
                    ),
                  ),
                ],
              )
            else
              Text('Score so far: $_correct / $_total', style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}

class _CardFace extends StatelessWidget {
  final Color color;
  final Widget child;
  const _CardFace({required this.color, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 260),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
      child: child,
    );
  }
}

class _TranslationRow extends StatelessWidget {
  final String label;
  final String text;
  final VoidCallback onSpeak;
  const _TranslationRow({required this.label, required this.text, required this.onSpeak});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: Colors.black54)),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Flexible(
              child: Text(text, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
            ),
            IconButton(icon: const Icon(Icons.volume_up), onPressed: onSpeak),
          ],
        ),
      ],
    );
  }
}
