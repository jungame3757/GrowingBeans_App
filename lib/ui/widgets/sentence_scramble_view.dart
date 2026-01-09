import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class SentenceScrambleView extends StatefulWidget {
  final List<String> userWords;
  final List<String> scrambleWords;
  final String correctSentence; // Added parameter
  final List<int> usedWordIndices;
  final Function(int) onAddWord;
  final Function(int) onRemoveWord;

  const SentenceScrambleView({
    super.key,
    required this.userWords,
    required this.scrambleWords,
    required this.correctSentence, // Added parameter
    required this.usedWordIndices,
    required this.onAddWord,
    required this.onRemoveWord,
  });

  @override
  State<SentenceScrambleView> createState() => _SentenceScrambleViewState();
}

class _SentenceScrambleViewState extends State<SentenceScrambleView> with SingleTickerProviderStateMixin {
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
          // Composition Area (Sentence being successfully built)
          Container(
            constraints: const BoxConstraints(minHeight: 80),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            child: Wrap(
              spacing: 12, // Increased spacing
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: List.generate(widget.correctSentence.split(' ').length, (index) { // Use split(' ').length
                if (index < widget.userWords.length) {
                  return MockEntryAnimation(
                    key: ValueKey('user_word_$index'),
                    child: _buildWordChip(
                      widget.userWords[index],
                      onTap: () => widget.onRemoveWord(index),
                      isFilled: true,
                    ),
                  );
                } else {
                  // Pass the correct word for this slot to calculate width
                  String targetWord = widget.correctSentence.split(' ')[index];
                  return _buildEmptySlot(targetWord); 
                }
              }),
            ),
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
          
          // Selection Area (Available words)
          AnimatedBuilder(
            animation: _entryController,
            builder: (context, child) {
              return Wrap(
                spacing: 24, // Min 24dp spacing per guide
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: widget.scrambleWords.asMap().entries.map((entry) {
                  int idx = entry.key;
                  String word = entry.value;
                  bool isUsed = widget.usedWordIndices.contains(idx);

                  // Staggered Entry Animation
                  final double start = (idx / widget.scrambleWords.length) * 0.5;
                  final double end = start + 0.5;
                  
                  final curve = CurvedAnimation(
                    parent: _entryController,
                    curve: Interval(start, end, curve: Curves.easeOutBack),
                  );

                  Widget chip = FadeTransition(
                    opacity: curve,
                    child: SlideTransition(
                      position: Tween<Offset>(
                        begin: const Offset(0, 0.5),
                        end: Offset.zero,
                      ).animate(curve),
                      child: _buildWordChip(
                        word,
                        onTap: () => widget.onAddWord(idx),
                        isFilled: false,
                      ),
                    ),
                  );

                  // Scale + Fade when selected
                  return AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: isUsed ? 0.0 : 1.0,
                    curve: Curves.easeOut,
                    child: AnimatedScale(
                      duration: const Duration(milliseconds: 300),
                      scale: isUsed ? 0.0 : 1.0,
                      curve: Curves.easeOutBack,
                      child: IgnorePointer(
                        ignoring: isUsed,
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

  Widget _buildWordChip(String word, {VoidCallback? onTap, bool isFilled = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // Increased padding for touch target
        constraints: const BoxConstraints(minHeight: 72, minWidth: 72), // Minimum touch target size
        decoration: BoxDecoration(
          color: isFilled ? Colors.amber[700] : Colors.white, // Vivid Amber for active state
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isFilled ? Colors.amber[800]! : Colors.grey[300]!,
            width: 3, // Thicker border
          ),
          boxShadow: [
            BoxShadow(
              color: (isFilled ? Colors.amber[900]! : Colors.black).withOpacity(isFilled ? 0.2 : 0.1),
              offset: const Offset(0, 6), // Deeper shadow
              blurRadius: 0, // Sharp shadow for cartoon look
            ),
          ],
        ),
        child: Column( // Use Column to center vertically if needed, or just Center
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              word,
              style: TextStyle(
                fontSize: 24, // Larger font
                fontWeight: FontWeight.w900,
                color: isFilled ? Colors.white : Colors.indigo[900], // High contrast Indigo
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptySlot(String targetWord) {
    // Calculate dynamic width based on text length
    // Base width 72 (padding 24*2 + min content) ~ approx 
    // Let's approximate: 24 (padding L) + 24 (padding R) + (fontSize 24 * 0.6 * length)
    // 0.6 is a rough estimator for character width factor
    double estimatedWidth = 48 + (24 * 0.6 * targetWord.length);
    double width = estimatedWidth < 72 ? 72 : estimatedWidth;

    return Container(
      width: width, // Dynamic width
      height: 72,
      decoration: BoxDecoration(
        color: Colors.brown[50],
        borderRadius: BorderRadius.circular(24),
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
