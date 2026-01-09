import 'package:flutter_test/flutter_test.dart';
import 'package:growing_beans/data/models/question_model.dart';
import 'package:growing_beans/logic/script_parser.dart';

void main() {
  test('ScriptParser parses lines into ALL Words and Sentence Scramble questions', () {
    const script = '''
I can see the sky.
''';

    final questions = ScriptParser.parseScript(script);

    // Sentence: "I can see the sky"
    // Words (len>=1): "I", "can", "see", "the", "sky" -> 5 words
    // Sentence Scramble: 1
    // Total: 6 questions
    expect(questions.length, 6);

    // Q1: I
    expect(questions[0].type, QuestionType.wordScramble);
    expect(questions[0].correctWord, 'I');

    // Q2: can
    expect(questions[1].type, QuestionType.wordScramble);
    expect(questions[1].correctWord, 'can');

    // Q3: see
    expect(questions[2].type, QuestionType.wordScramble);
    expect(questions[2].correctWord, 'see');

    // Q4: the
    expect(questions[3].type, QuestionType.wordScramble);
    expect(questions[3].correctWord, 'the');

    // Q5: sky
    expect(questions[4].type, QuestionType.wordScramble);
    expect(questions[4].correctWord, 'sky');
    
    // Q6: Sentence
    expect(questions[5].type, QuestionType.sentenceScramble);
    expect(questions[5].correctSentence, 'I can see the sky.');
  });
}
