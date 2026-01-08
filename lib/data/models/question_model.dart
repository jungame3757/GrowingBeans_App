enum QuestionType {
  multipleChoice,
  trueFalse,
  imageMatch,
  wordScramble,
}

class Question {
  final String id;
  final String text;
  final QuestionType type;
  final List<String> options;
  final int correctAnswerIndex;
  final String? imageUrl;
  final String? audioUrl;
  final String? correctWord;
  final List<String>? scrambleLetters;

  Question({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
    required this.correctAnswerIndex,
    this.imageUrl,
    this.audioUrl,
    this.correctWord,
    this.scrambleLetters,
  });

  // Specific mock for Multiple Choice
  static List<Question> mockQuiz() {
    return [
      Question(
        id: "q_1",
        text: "What color is the sun?",
        type: QuestionType.multipleChoice,
        options: ["Yellow", "Blue", "Green", "Red"],
        correctAnswerIndex: 0,
      ),
      Question(
        id: "q_2",
        text: "Apple starts with which letter?",
        type: QuestionType.multipleChoice,
        options: ["A", "B", "C", "D"],
        correctAnswerIndex: 0,
      ),
      Question(
        id: "q_3",
        text: "Which of these is a fruit?",
        type: QuestionType.multipleChoice,
        options: ["Carrot", "Banana", "Broccoli", "Potato"],
        correctAnswerIndex: 1,
      ),
    ];
  }

  // Specific mock for Word Scramble
  static List<Question> mockScramble() {
    return [
      Question(
        id: "s_1",
        text: "Arrange the letters to form the word:",
        type: QuestionType.wordScramble,
        options: [],
        correctAnswerIndex: -1,
        correctWord: "APPLE",
        scrambleLetters: ["P", "A", "L", "E", "P"],
      ),
      Question(
        id: "s_2",
        text: "Arrange the letters to form the word:",
        type: QuestionType.wordScramble,
        options: [],
        correctAnswerIndex: -1,
        correctWord: "GRAPE",
        scrambleLetters: ["R", "A", "G", "E", "P"],
      ),
      Question(
        id: "s_3",
        text: "Arrange the letters to form the word:",
        type: QuestionType.wordScramble,
        options: [],
        correctAnswerIndex: -1,
        correctWord: "BANANA",
        scrambleLetters: ["N", "A", "B", "A", "N", "A"],
      ),
    ];
  }
}
