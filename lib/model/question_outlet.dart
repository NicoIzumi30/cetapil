class Question {
  final String id;
  final String question;
  final String type;

  Question({required this.id, required this.question, required this.type});

  // Factory method to create a Question from a JSON map
  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      type: json['type'],
    );
  }
}
