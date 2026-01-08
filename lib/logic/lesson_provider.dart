import 'package:flutter/material.dart';
import '../data/models/lesson_model.dart';
import '../data/models/question_model.dart';

class LessonProvider extends ChangeNotifier {
  final Lesson lesson;
  int _currentQuestionIndex = 0;
  bool _isLessonComplete = false;
  int? _selectedOptionIndex;
  bool? _isCorrect;

  LessonProvider({required this.lesson});

  // Getters
  int get currentQuestionIndex => _currentQuestionIndex;
  Question get currentQuestion => lesson.questions[_currentQuestionIndex];
  double get progress => lesson.getProgress(_currentQuestionIndex);
  bool get isLessonComplete => _isLessonComplete;
  int? get selectedOptionIndex => _selectedOptionIndex;
  bool? get isCorrect => _isCorrect;

  // Actions
  void selectOption(int index) {
    if (_isCorrect != null) return; // Already checked
    _selectedOptionIndex = index;
    notifyListeners();
  }

  void checkAnswer() {
    if (_selectedOptionIndex == null) return;
    
    _isCorrect = (_selectedOptionIndex == currentQuestion.correctAnswerIndex);
    notifyListeners();
  }

  void nextQuestion() {
    if (_currentQuestionIndex < lesson.questions.length - 1) {
      _currentQuestionIndex++;
      _resetQuestionState();
    } else {
      _isLessonComplete = true;
    }
    notifyListeners();
  }

  void _resetQuestionState() {
    _selectedOptionIndex = null;
    _isCorrect = null;
  }
}
