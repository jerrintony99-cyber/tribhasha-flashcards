/// Represents a single trilingual flashcard.
/// Each card holds the same word/phrase in English, Malayalam and Kannada,
/// plus metadata used for categorisation and simple spaced-repetition style
/// tracking (timesReviewed / timesCorrect) used on the Quiz screen.
class Flashcard {
  String id;
  String english;
  String malayalam;
  String kannada;
  String category; // e.g. Greetings, Food, Numbers, Family, Travel
  int timesReviewed;
  int timesCorrect;
  bool isFavorite;

  Flashcard({
    required this.id,
    required this.english,
    required this.malayalam,
    required this.kannada,
    required this.category,
    this.timesReviewed = 0,
    this.timesCorrect = 0,
    this.isFavorite = false,
  });

  double get accuracy =>
      timesReviewed == 0 ? 0 : (timesCorrect / timesReviewed) * 100;

  Map<String, dynamic> toJson() => {
        'id': id,
        'english': english,
        'malayalam': malayalam,
        'kannada': kannada,
        'category': category,
        'timesReviewed': timesReviewed,
        'timesCorrect': timesCorrect,
        'isFavorite': isFavorite,
      };

  factory Flashcard.fromJson(Map<String, dynamic> json) => Flashcard(
        id: json['id'],
        english: json['english'],
        malayalam: json['malayalam'],
        kannada: json['kannada'],
        category: json['category'],
        timesReviewed: json['timesReviewed'] ?? 0,
        timesCorrect: json['timesCorrect'] ?? 0,
        isFavorite: json['isFavorite'] ?? false,
      );
}
