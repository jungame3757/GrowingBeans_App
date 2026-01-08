import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../logic/lesson_provider.dart';
import '../../core/app_theme.dart';
import '../widgets/top_progress_bar.dart';
import '../widgets/choice_card.dart';

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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
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
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Colors.brown[800],
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 40),
                    // Choices
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
    VoidCallback? onPressed = provider.selectedOptionIndex == null ? null : provider.checkAnswer;

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
                    : provider.selectedOptionIndex == null ? Colors.grey[300] : AppTheme.secondaryColor,
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
