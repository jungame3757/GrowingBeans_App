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
        borderColor = AppTheme.greenColor;
        backgroundColor = AppTheme.greenColor.withOpacity(0.1);
      } else {
        borderColor = AppTheme.errorColor;
        backgroundColor = AppTheme.errorColor.withOpacity(0.1);
      }
    }

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 3),
          boxShadow: isSelected
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    offset: const Offset(0, 4),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
