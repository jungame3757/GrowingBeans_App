import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class WordScrambleView extends StatefulWidget {
  final List<String> userLetters;
  final List<String> scrambleLetters;
  final List<int> usedLetterIndices;
  final int targetLength;
  final Function(int) onAddLetter;
  final Function(int) onRemoveLetter;

  const WordScrambleView({
    super.key,
    required this.userLetters,
    required this.scrambleLetters,
    required this.usedLetterIndices,
    required this.targetLength,
    required this.onAddLetter,
    required this.onRemoveLetter,
  });

  @override
  State<WordScrambleView> createState() => _WordScrambleViewState();
}

class _WordScrambleViewState extends State<WordScrambleView> with SingleTickerProviderStateMixin {
  late AnimationController _entryController;

  @override
  void initState() {
    super.initState();
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _entryController.forward();
  }

  @override
  void dispose() {
    _entryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          // Composition Area
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: List.generate(widget.targetLength, (index) {
              if (index < widget.userLetters.length) {
                // 입력된 글자: "Pop" 효과 (Elastic Curve)
                return MockEntryAnimation(
                  key: ValueKey('user_letter_$index'), // Rebuild 시 애니메이션 트리거
                  child: _buildLetterTile(
                    widget.userLetters[index],
                    onTap: () => widget.onRemoveLetter(index),
                    isFilled: true,
                  ),
                );
              }
              return _buildEmptySlot();
            }),
          ),
          const SizedBox(height: 40),
          // Divider
          Container(
            height: 2,
            width: 60,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(1),
            ),
          ),
          const SizedBox(height: 40),
          // Selection Area
          AnimatedBuilder(
            animation: _entryController,
            builder: (context, child) {
               return Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: widget.scrambleLetters.asMap().entries.map((entry) {
                  int idx = entry.key;
                  String letter = entry.value;
                  bool isUsed = widget.usedLetterIndices.contains(idx);

                  // Staggered Entry Animation
                  // 각 아이템마다 0.0~1.0 사이의 구간을 할당하여 애니메이션 실행
                  final double start = (idx / widget.scrambleLetters.length) * 0.5;
                  final double end = start + 0.5;
                  
                  final curve = CurvedAnimation(
                    parent: _entryController,
                    curve: Interval(start, end, curve: Curves.easeOutBack),
                  );

                  // 진입 애니메이션 (Slide + Fade)
                  Widget chip = FadeTransition(
                    opacity: curve,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(curve),
                      child: _buildLetterTile(
                        letter,
                        onTap: () => widget.onAddLetter(idx),
                        isFilled: false,
                      ),
                    ),
                  );

                  // 선택/해제 애니메이션 (Scale + Fade)
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: isUsed ? 0.0 : 1.0,
                    curve: Curves.easeOut,
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 300),
                      scale: isUsed ? 0.0 : 1.0,
                      curve: Curves.easeOutBack,
                      child: IgnorePointer(
                        ignoring: isUsed, // 이미 사용된 카드는 터치 무시
                        child: chip,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLetterTile(String letter, {VoidCallback? onTap, bool isFilled = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container( // AnimatedContainer 제거 (상위에서 애니메이션 처리)
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          color: isFilled ? AppTheme.secondaryColor : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isFilled ? AppTheme.secondaryColor : Colors.grey[300]!,
            width: 3,
          ),
          boxShadow: [
            BoxShadow(
              color: (isFilled ? AppTheme.secondaryColor : Colors.black).withOpacity(0.15),
              offset: const Offset(0, 4),
              blurRadius: 0,
            ),
          ],
        ),
        child: Center(
          child: Text(
            letter,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: isFilled ? Colors.white : Colors.brown[700],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySlot() {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: Colors.brown[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.brown[100]!,
          width: 3,
          style: BorderStyle.solid,
        ),
      ),
      child: Center(
        child: Container(
          width: 20,
          height: 6,
          decoration: BoxDecoration(
            color: Colors.brown[100],
            borderRadius: BorderRadius.circular(3),
          ),
        ),
      ),
    );
  }
}

// 간단한 "Pop" 등장 효과를 위한 위젯
class MockEntryAnimation extends StatefulWidget {
  final Widget child;
  const MockEntryAnimation({super.key, required this.child});

  @override
  State<MockEntryAnimation> createState() => _MockEntryAnimationState();
}

class _MockEntryAnimationState extends State<MockEntryAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.elasticOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: widget.child,
    );
  }
}

