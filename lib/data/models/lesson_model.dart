import 'question_model.dart';

class Lesson {
  final String id;
  final String title;
  final String description;
  final List<Question> questions;
  final int level;

  Lesson({
    required this.id,
    required this.title,
    required this.description,
    required this.questions,
    this.level = 1,
  });

  double getProgress(int currentQuestionIndex) {
    if (questions.isEmpty) return 0.0;
    return (currentQuestionIndex) / questions.length;
  }
}
