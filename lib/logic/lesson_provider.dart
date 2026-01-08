import 'package:flutter/material.dart';
import '../data/models/lesson_model.dart';
import '../data/models/question_model.dart';

class LessonProvider extends ChangeNotifier {
  final Lesson lesson;
  int _currentQuestionIndex = 0;
  bool _isLessonComplete = false;
  int? _selectedOptionIndex;
  bool? _isCorrect;
  
  // Word Scramble State
  List<String> _userLetters = [];
  List<int> _usedLetterIndices = []; // Track indices of scrambleLetters used

  LessonProvider({required this.lesson});

  // Getters
  int get currentQuestionIndex => _currentQuestionIndex;
  Question get currentQuestion => lesson.questions[_currentQuestionIndex];
  double get progress => lesson.getProgress(_currentQuestionIndex);
  bool get isLessonComplete => _isLessonComplete;
  int? get selectedOptionIndex => _selectedOptionIndex;
  bool? get isCorrect => _isCorrect;
  List<String> get userLetters => _userLetters;
  List<int> get usedLetterIndices => _usedLetterIndices;

  // Actions
  void selectOption(int index) {
    if (_isCorrect != null) return; // Already checked
    _selectedOptionIndex = index;
    notifyListeners();
  }

  void addLetter(int index) {
    if (_isCorrect != null || currentQuestion.type != QuestionType.wordScramble) return;
    if (_usedLetterIndices.contains(index)) return;

    final letters = currentQuestion.scrambleLetters;
    if (letters != null && index < letters.length) {
      _userLetters.add(letters[index]);
      _usedLetterIndices.add(index);
      notifyListeners();
    }
  }

  void removeLetter(int userLetterIndex) {
    if (_isCorrect != null || currentQuestion.type != QuestionType.wordScramble) return;
    
    if (userLetterIndex < _userLetters.length) {
      _userLetters.removeAt(userLetterIndex);
      _usedLetterIndices.removeAt(userLetterIndex);
      notifyListeners();
    }
  }

  void checkAnswer() {
    if (currentQuestion.type == QuestionType.wordScramble) {
      final inputWord = _userLetters.join('');
      _isCorrect = (inputWord == currentQuestion.correctWord);
    } else {
      if (_selectedOptionIndex == null) return;
      _isCorrect = (_selectedOptionIndex == currentQuestion.correctAnswerIndex);
    }
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
    _userLetters = [];
    _usedLetterIndices = [];
  }
}
