import '../data/models/question_model.dart';
import 'scramble_generator.dart';

class ScriptParser {
  /// Parses a script string and returns a list of Questions.
  /// 
  /// For each line in the script:
  /// 1. Extracts a keyword (longest word >= 3 chars) -> Word Scramble Question
  /// 2. Uses the full line -> Sentence Scramble Question
  static List<Question> parseScript(String scriptContent) {
    List<Question> questions = [];
    int idCounter = 1;

    // Split script into lines and filter empty ones
    final lines = scriptContent
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    for (var line in lines) {
      // 1. Generate Word Scramble Question for ALL valid words
      final List<String> words = _extractAllWords(line);
      
      for (var word in words) {
        questions.add(Question(
          id: 'script_word_$idCounter',
          text: 'Guess the word!',
          type: QuestionType.wordScramble,
          options: [],
          correctAnswerIndex: -1,
          correctWord: word,
          scrambleLetters: ScrambleGenerator.generateWordScramble(word),
        ));
        idCounter++;
      }

      // 2. Generate Sentence Scramble Question
      questions.add(Question(
        id: 'script_sentence_$idCounter',
        text: 'Make the sentence!',
        type: QuestionType.sentenceScramble,
        options: [],
        correctAnswerIndex: -1,
        correctSentence: line,
        scrambleWords: ScrambleGenerator.generateSentenceScramble(line),
      ));
      idCounter++;
    }

    return questions;
  }

  /// Extracts all valid words from the sentence.
  /// Valid word: length >= 2 (to be scramblable)
  static List<String> _extractAllWords(String sentence) {
    // Remove punctuation
    final cleanSentence = sentence.replaceAll(RegExp(r'[^\w\s]'), '');
    final words = cleanSentence.split(RegExp(r'\s+'));
    
    // Filter words with length >= 2 and remove duplicates if needed (optional)
    // For a learning flow, maybe we want to test duplicate words again or just unique ones?
    // "I can see the sky." -> "can", "see", "the", "sky"
    // Usually unique is better to avoid boredom.
    return words.where((w) => w.length >= 1).toSet().toList();
  }
}
