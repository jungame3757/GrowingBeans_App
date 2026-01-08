import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/lesson_provider.dart';
import '../../core/app_theme.dart';
import '../widgets/top_progress_bar.dart';
import '../widgets/choice_card.dart';
import '../widgets/word_scramble_view.dart';
import '../../data/models/question_model.dart';

class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LessonProvider>(context);
    final question = provider.currentQuestion;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Top Bar with Close button and Progress
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey, size: 30),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(child: TopProgressBar(progress: provider.progress)),
                ],
              ),
            ),

            // Question Content
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        'Match the word:',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey[600],
                              letterSpacing: 1.2,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        question.text,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              color: Colors.brown[800],
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 20),
                      // Choices or Scramble View
                      if (question.type == QuestionType.wordScramble)
                        WordScrambleView(
                          userLetters: provider.userLetters,
                          scrambleLetters: question.scrambleLetters ?? [],
                          usedLetterIndices: provider.usedLetterIndices,
                          targetLength: question.correctWord?.length ?? 0,
                          onAddLetter: (idx) => provider.addLetter(idx),
                          onRemoveLetter: (idx) => provider.removeLetter(idx),
                        )
                      else
                        ...question.options.asMap().entries.map((entry) {
                          int idx = entry.key;
                          String val = entry.value;
                          return ChoiceCard(
                            text: val,
                            isSelected: provider.selectedOptionIndex == idx,
                            isCorrect: provider.isCorrect,
                            onTap: () => provider.selectOption(idx),
                          );
                        }).toList(),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Feedback Bar
            _buildBottomBar(context, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context, LessonProvider provider) {
    bool isAnswerChecked = provider.isCorrect != null;
    Color barColor = Colors.white;
    String buttonText = "CHECK";
    
    bool canCheck = false;
    if (provider.currentQuestion.type == QuestionType.wordScramble) {
      canCheck = provider.userLetters.isNotEmpty;
    } else {
      canCheck = provider.selectedOptionIndex != null;
    }

    VoidCallback? onPressed = !canCheck ? null : provider.checkAnswer;

    if (isAnswerChecked) {
      barColor = provider.isCorrect! ? AppTheme.greenColor.withOpacity(0.2) : AppTheme.errorColor.withOpacity(0.2);
      buttonText = "CONTINUE";
      onPressed = provider.nextQuestion;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: barColor,
        border: Border(top: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isAnswerChecked) ...[
            Row(
              children: [
                Icon(
                  provider.isCorrect! ? Icons.check_circle : Icons.error,
                  color: provider.isCorrect! ? AppTheme.greenColor : AppTheme.errorColor,
                  size: 30,
                ),
                const SizedBox(width: 12),
                Text(
                  provider.isCorrect! ? "Great Job!" : "Not quite right",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: provider.isCorrect! ? AppTheme.greenColor : AppTheme.errorColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: isAnswerChecked
                    ? (provider.isCorrect! ? AppTheme.greenColor : AppTheme.errorColor)
                    : (!canCheck) ? Colors.grey[300] : AppTheme.secondaryColor,
                elevation: 0,
              ),
              child: Text(buttonText),
            ),
          ),
        ],
      ),
    );
  }
}
