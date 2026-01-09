import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import '../../logic/lesson_provider.dart';
import '../../core/app_theme.dart';
import '../widgets/top_progress_bar.dart';
import '../widgets/choice_card.dart';
import '../widgets/word_scramble_view.dart';
import '../widgets/sentence_scramble_view.dart';
import '../../data/models/question_model.dart';

class LessonScreen extends StatefulWidget {
  const LessonScreen({super.key});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  // 문제 전환 시 이전 상태를 잠시 유지하여 깜빡임 방지
  bool? _lastIsCorrect;
  Question? _lastQuestion;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LessonProvider>(context);
    
    // 완료 화면 처리
    if (provider.isLessonComplete) {
      return Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.stars_rounded, color: AppTheme.primaryColor, size: 100),
              const SizedBox(height: 24),
              const Text(
                '참 잘했어요! 👏',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.brown),
              ),
              const SizedBox(height: 12),
              const Text('오늘의 공부를 모두 마쳤어!', style: TextStyle(fontSize: 18, color: Colors.brown)),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('목록으로 돌아가기'),
              ),
            ],
          ),
        ),
      );
    }

    final question = provider.currentQuestion;
    
    // 피드백 바 상태 업데이트 (안정성 강화)
    if (provider.isCorrect != null) {
      _lastIsCorrect = provider.isCorrect;
      _lastQuestion = question;
    }

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Top Bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
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
                const SizedBox(height: 16),
                // Question Content with AnimatedSwitcher to prevent flicker
                Expanded(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    reverseDuration: const Duration(milliseconds: 500),
                    switchInCurve: Curves.easeOutQuad,
                    switchOutCurve: Curves.easeInQuad,
                    transitionBuilder: (child, animation) {
                      final currentKey = ValueKey('question_${question.id}');
                      final isEntering = child.key == currentKey;
                      
                      // Toss 스타일: 살짝 미끄러지면서 페이드 (0.2 정도의 오프셋)
                      // 퇴장 시 애니메이션이 1.0 -> 0.0으로 진행되므로 Tween의 begin/end를 이에 맞춰 설정해야 함
                      // Exit (1->0): 1.0일 때 Center(0), 0.0일 때 Left(-0.2)여야 함 -> Tween(begin: -0.2, end: 0)
                      final offsetAnimation = isEntering
                          ? Tween<Offset>(begin: const Offset(0.2, 0.0), end: Offset.zero).animate(animation)
                          : Tween<Offset>(begin: const Offset(-0.2, 0.0), end: Offset.zero).animate(animation);
                      
                      // Opacity도 동일: Exit (1->0): 1.0일 때 1.0(보임), 0.0일 때 0.0(투명) -> Tween(begin: 0, end: 1)
                      final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(animation);

                      return SlideTransition(
                        position: offsetAnimation,
                        child: FadeTransition(
                          opacity: fadeAnimation,
                          child: child,
                        ),
                      );
                    },
                    child: SingleChildScrollView(
                      key: ValueKey('question_${question.id}'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 20),
                            _buildQuestionHeader(context, question),
                            const SizedBox(height: 32),
                            _buildQuestionBody(provider, question),
                            const SizedBox(height: 156), // 피드백 바 공간 확보
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Persistent Feedback Bar
            _buildFeedbackBar(context, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionHeader(BuildContext context, Question question) {
    return Column(
      children: [
        Text(
          'Match the word:',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.brown[400],
                letterSpacing: 1.2,
              ),
        ),
        const SizedBox(height: 16),
        Text(
          question.text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Colors.brown[900],
                fontWeight: FontWeight.w900,
              ),
        ),
      ],
    );
  }

  Widget _buildQuestionBody(LessonProvider provider, Question question) {
    if (question.type == QuestionType.wordScramble) {
      return WordScrambleView(
        key: ValueKey('scramble_${question.id}'),
        userLetters: provider.userLetters,
        scrambleLetters: question.scrambleLetters ?? [],
        usedLetterIndices: provider.usedLetterIndices,
        targetLength: question.correctWord?.length ?? 0,
        onAddLetter: (idx) => provider.addLetter(idx),
        onRemoveLetter: (idx) => provider.removeLetter(idx),
      );
    } else if (question.type == QuestionType.sentenceScramble) {
      return SentenceScrambleView(
        key: ValueKey('sentence_${question.id}'),
        userWords: provider.userWords,
        scrambleWords: question.scrambleWords ?? [],
        correctSentence: question.correctSentence ?? "", // Pass real data
        usedWordIndices: provider.usedWordIndices,
        onAddWord: (idx) => provider.addWord(idx),
        onRemoveWord: (idx) => provider.removeWord(idx),
      );
    } else {
      return Column(
        key: ValueKey('choice_col_${question.id}'),
        children: question.options.asMap().entries.map((entry) {
          int idx = entry.key;
          String val = entry.value;
          return ChoiceCard(
            key: ValueKey('choice_${question.id}_$idx'),
            text: val,
            isSelected: provider.selectedOptionIndex == idx,
            isCorrect: provider.isCorrect,
            onTap: () => provider.selectOption(idx),
          );
        }).toList(),
      );
    }
  }

  Widget _buildFeedbackBar(BuildContext context, LessonProvider provider) {
    final bool isVisible = provider.isCorrect != null;
    final bool? isCorrect = isVisible ? provider.isCorrect : _lastIsCorrect;
    final Question? displayQuestion = isVisible ? provider.currentQuestion : _lastQuestion;

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 600),
      curve: Curves.fastOutSlowIn,
      bottom: isVisible ? 0 : -350, // 더 안전하게 숨김
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(24, 24, 24, MediaQuery.of(context).padding.bottom + 24),
        decoration: BoxDecoration(
          color: (isCorrect ?? false)
              ? AppTheme.successColor.withOpacity(0.95)
              : AppTheme.errorColor.withOpacity(0.95),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(36)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: Row(
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0.0, end: isVisible ? 1.0 : 0.0),
              duration: const Duration(milliseconds: 500),
              curve: isVisible ? Curves.elasticOut : Curves.easeOutCubic,
              builder: (context, value, child) {
                // 음수가 되지 않도록 원천 차단 (Assertion Error 방지 핵심)
                return Transform.scale(
                  scale: math.max(0.0, value),
                  child: child,
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  (isCorrect ?? false) ? Icons.sentiment_very_satisfied_rounded : Icons.sentiment_dissatisfied_rounded,
                  color: (isCorrect ?? false) ? AppTheme.successColor : AppTheme.errorColor,
                  size: 44,
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isCorrect != null)
                    Text(
                      isCorrect ? '우와! 정답이야! 🌟' : '아이고, 조금만 더 힘내! 💪',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  if (isVisible && !isCorrect! && 
                      displayQuestion?.type == QuestionType.multipleChoice &&
                      displayQuestion!.correctAnswerIndex < displayQuestion.options.length)
                    Text(
                      '정답: ${displayQuestion.options[displayQuestion.correctAnswerIndex]}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
