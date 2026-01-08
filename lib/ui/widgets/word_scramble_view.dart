import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class WordScrambleView extends StatelessWidget {
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
            children: List.generate(targetLength, (index) {
              if (index < userLetters.length) {
                return _buildLetterTile(
                  userLetters[index],
                  onTap: () => onRemoveLetter(index),
                  isFilled: true,
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
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: scrambleLetters.asMap().entries.map((entry) {
              int idx = entry.key;
              String letter = entry.value;
              bool isUsed = usedLetterIndices.contains(idx);

              return Opacity(
                opacity: isUsed ? 0.0 : 1.0,
                child: IgnorePointer(
                  ignoring: isUsed,
                  child: _buildLetterTile(
                    letter,
                    onTap: () => onAddLetter(idx),
                    isFilled: false,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLetterTile(String letter, {VoidCallback? onTap, bool isFilled = false}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isFilled ? AppTheme.secondaryColor : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isFilled ? AppTheme.secondaryColor : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: [
            if (!isFilled)
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Center(
          child: Text(
            letter,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isFilled ? Colors.white : Colors.brown[700],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptySlot() {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.grey[200]!,
          width: 2,
          style: BorderStyle.solid,
        ),
      ),
    );
  }
}
