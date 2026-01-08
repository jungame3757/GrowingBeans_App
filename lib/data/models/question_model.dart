enum QuestionType {
  multipleChoice,
  trueFalse,
  imageMatch,
}

class Question {
  final String id;
  final String text;
  final QuestionType type;
  final List<String> options;
  final int correctAnswerIndex;
  final String? imageUrl;
  final String? audioUrl;

  Question({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
    required this.correctAnswerIndex,
    this.imageUrl,
    this.audioUrl,
  });

  // Example factory for mock data
  factory Question.mock(int index) {
    return Question(
      id: "q_$index",
      text: index % 2 == 0 ? "What color is the sun?" : "Apple starts with which letter?",
      type: QuestionType.multipleChoice,
      options: index % 2 == 0 ? ["Yellow", "Blue", "Green", "Red"] : ["A", "B", "C", "D"],
      correctAnswerIndex: 0,
    );
  }
}
