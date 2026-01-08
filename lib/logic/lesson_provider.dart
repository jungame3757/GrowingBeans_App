import 'package:flutter/material.dart';
import 'dart:async';
import '../data/models/lesson_model.dart';
import '../data/models/question_model.dart';

class LessonProvider extends ChangeNotifier {
  final Lesson lesson;
  int _currentQuestionIndex = 0;
  bool _isLessonComplete = false;
  int? _selectedOptionIndex;
  bool? _isCorrect;
  Timer? _autoNextTimer;
  
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
    checkAnswer(); // 자동 확인 추가
  }

  void addLetter(int index) {
    if (_isCorrect != null || currentQuestion.type != QuestionType.wordScramble) return;
    if (_usedLetterIndices.contains(index)) return;

    final letters = currentQuestion.scrambleLetters;
    if (letters != null && index < letters.length) {
      _userLetters.add(letters[index]);
      _usedLetterIndices.add(index);
      notifyListeners();

      // 모든 글자가 채워지면 자동 확인
      if (_userLetters.length == currentQuestion.correctWord?.length) {
        checkAnswer();
      }
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

    // 정답 확인 후 3초 뒤 자동 다음 문제 이동
    _autoNextTimer?.cancel();
    _autoNextTimer = Timer(const Duration(seconds: 3), () {
      nextQuestion();
    });
  }

  void nextQuestion() {
    _autoNextTimer?.cancel();
    _autoNextTimer = null;

    if (_currentQuestionIndex < lesson.questions.length - 1) {
      _currentQuestionIndex++;
      _resetQuestionState();
    } else {
      _isLessonComplete = true;
    }
    notifyListeners();
  }

  void _resetQuestionState() {
    _autoNextTimer?.cancel();
    _autoNextTimer = null;
    _selectedOptionIndex = null;
    _isCorrect = null;
    _userLetters = [];
    _usedLetterIndices = [];
  }

  @override
  void dispose() {
    _autoNextTimer?.cancel();
    super.dispose();
  }
}
