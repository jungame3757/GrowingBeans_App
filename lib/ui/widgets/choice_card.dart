import 'package:flutter/material.dart';
import '../../core/app_theme.dart';

class ChoiceCard extends StatelessWidget {
  final String text;
  final bool isSelected;
  final bool? isCorrect;
  final VoidCallback onTap;

  const ChoiceCard({
    super.key,
    required this.text,
    required this.isSelected,
    this.isCorrect,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Color borderColor = Colors.grey[300]!;
    Color backgroundColor = Colors.white;
    Color textColor = Colors.brown[700]!;

    if (isSelected) {
      borderColor = AppTheme.secondaryColor;
      backgroundColor = AppTheme.secondaryColor.withOpacity(0.1);
    }

    if (isCorrect != null && isSelected) {
      if (isCorrect!) {
        borderColor = AppTheme.successColor;
        backgroundColor = AppTheme.successColor.withOpacity(0.1);
      } else {
        borderColor = AppTheme.errorColor;
        backgroundColor = AppTheme.errorColor.withOpacity(0.1);
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: isSelected ? 0.96 : 1.0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutBack,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(vertical: 12),
          constraints: const BoxConstraints(minHeight: 84),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 28),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: borderColor, 
              width: isSelected ? 4 : 2,
            ),
            boxShadow: [
              BoxShadow(
                color: borderColor.withOpacity(0.3),
                offset: isSelected ? const Offset(0, 2) : const Offset(0, 8),
                blurRadius: isSelected ? 2 : 0,
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
