import 'dart:math';

class ScrambleGenerator {
  static final Random _random = Random();

  /// Scrambles the letters of a word.
  /// Ensures the result is not identical to the original word if possible.
  static List<String> generateWordScramble(String word) {
    if (word.isEmpty) return [];
    
    List<String> letters = word.split('');
    if (letters.length <= 1) return letters;

    // Try to shuffle until it's different from original
    // Limit attempts to avoid infinite loops for words like "AA"
    int attempts = 0;
    String original = word;
    String scrambled;
    
    do {
      letters.shuffle(_random);
      scrambled = letters.join('');
      attempts++;
    } while (scrambled == original && attempts < 10);

    return letters;
  }

  /// Scrambles the words of a sentence.
  /// Ensures the result is not identical to the original sentence.
  static List<String> generateSentenceScramble(String sentence) {
    if (sentence.isEmpty) return [];

    // Remove punctuation for scramble words (optional, but cleaner)
    // Or keep punctuation attached? 
    // Usually for sentence building, we want tokens.
    // Let's split by space.
    List<String> words = sentence.trim().split(RegExp(r'\s+'));
    
    if (words.length <= 1) return words;

    int attempts = 0;
    String original = words.join(' ');
    String scrambled;

    do {
      words.shuffle(_random);
      scrambled = words.join(' ');
      attempts++;
    } while (scrambled == original && attempts < 10);

    return words;
  }
}
