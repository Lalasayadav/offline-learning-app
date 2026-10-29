class Flashcard {
  final String id;
  final String question;
  final String answer;
  final String dueDate;

  Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    required this.dueDate,
  });

  // Convert a Flashcard object into a Map (for SQLite insertion)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'question': question,
      'answer': answer,
      'dueDate': dueDate,
    };
  }

  // Convert a Map (from SQLite row) into a Flashcard object
  factory Flashcard.fromMap(Map<String, dynamic> map) {
    return Flashcard(
      id: map['id'],
      question: map['question'],
      answer: map['answer'],
      dueDate: map['dueDate'],
    );
  }
}
