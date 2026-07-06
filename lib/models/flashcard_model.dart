class FlashcardModel {
  final int? id;
  final String question;
  final String answer;
  final String category;
  final DateTime createdAt;

  FlashcardModel({
    this.id,
    required this.question,
    required this.answer,
    required this.category,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory FlashcardModel.fromMap(Map<String, dynamic> map) {
    return FlashcardModel(
      id: map['id'],
      question: map['question'],
      answer: map['answer'],
      category: map['category'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  FlashcardModel copyWith({
    int? id,
    String? question,
    String? answer,
    String? category,
    DateTime? createdAt,
  }) {
    return FlashcardModel(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}