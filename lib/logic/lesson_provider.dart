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
  
  // Sentence Scramble State
  List<String> _userWords = [];
  List<int> _usedWordIndices = [];

  LessonProvider({required this.lesson});

  // Getters
  int get currentQuestionIndex => _currentQuestionIndex;
  Question get currentQuestion => lesson.questions[_currentQuestionIndex];
  double get progress {
    if (lesson.questions.isEmpty) return 0.0;
    int completedCount = _currentQuestionIndex;
    if (_isCorrect == true) {
      completedCount++;
    }
    return completedCount / lesson.questions.length;
  }
  bool get isLessonComplete => _isLessonComplete;
  int? get selectedOptionIndex => _selectedOptionIndex;
  bool? get isCorrect => _isCorrect;
  List<String> get userLetters => _userLetters;
  List<int> get usedLetterIndices => _usedLetterIndices;
  List<String> get userWords => _userWords;
  List<int> get usedWordIndices => _usedWordIndices;

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

  void addWord(int index) {
    if (_isCorrect != null || currentQuestion.type != QuestionType.sentenceScramble) return;
    if (_usedWordIndices.contains(index)) return;

    final words = currentQuestion.scrambleWords;
    if (words != null && index < words.length) {
      _userWords.add(words[index]);
      _usedWordIndices.add(index);
      notifyListeners();

      // Check if sentence is complete (based on length of correct sentence tokens or just number of words)
      // Comparing length of user words vs scramble words is one way, 
      // but correct sentence might use specific count. 
      // Safest is to check against scrambleWords length if we use all words.
      if (_userWords.length == words.length) {
        checkAnswer();
      }
    }
  }

  void removeWord(int userWordIndex) {
    if (_isCorrect != null || currentQuestion.type != QuestionType.sentenceScramble) return;

    if (userWordIndex < _userWords.length) {
      _userWords.removeAt(userWordIndex);
      _usedWordIndices.removeAt(userWordIndex);
      notifyListeners();
    }
  }

  void checkAnswer() {
    if (currentQuestion.type == QuestionType.wordScramble) {
      final inputWord = _userLetters.join('');
      _isCorrect = (inputWord == currentQuestion.correctWord);
    } else if (currentQuestion.type == QuestionType.sentenceScramble) {
      final inputSentence = _userWords.join(' ');
      // Compare with correctSentence (assuming spaces are consistent)
      // Or we could compare with the scrambleWords if we knew the correct order indices, 
      // but string comparison is easiest.
      _isCorrect = (inputSentence == currentQuestion.correctSentence);
    } else {
      if (_selectedOptionIndex == null) return;
      _isCorrect = (_selectedOptionIndex == currentQuestion.correctAnswerIndex);
    }
    
    notifyListeners();

    // 정답 확인 후 3초 뒤 자동 다음 문제 이동
    _autoNextTimer?.cancel();
    _autoNextTimer = Timer(const Duration(milliseconds: 1500), () {
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
    _userWords = [];
    _usedWordIndices = [];
  }

  @override
  void dispose() {
    _autoNextTimer?.cancel();
    super.dispose();
  }
}
