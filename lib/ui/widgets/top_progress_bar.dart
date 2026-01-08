import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../core/app_theme.dart';

class TopProgressBar extends StatelessWidget {
  final double progress;

  const TopProgressBar({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    // 런타임에 안전한 너비 계산을 위해 clamp 사용
    final double safeProgress = progress.clamp(0.0, 1.0);
    final double screenWidth = MediaQuery.of(context).size.width;
    final double maxWidth = math.max(0.0, screenWidth - 96);

    return Container(
      height: 28,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.brown[50]!, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.brown.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none, // 혹시 모를 오버플로우 방지
        children: [
          // 1. 메인 진행 바
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: safeProgress),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutQuint, // 더욱 부드럽고 안전한 커브로 변경
            builder: (context, value, child) {
              final double currentWidth = math.max(0.0, maxWidth * value);
              return Container(
                width: currentWidth,
                height: 28, // 높이 명시
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppTheme.successColor, Color(0xFF9CCC65)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
              );
            },
          ),
          // 2. 하이라이트 반사광 (Positioned를 Stack의 직계 자식으로 이동)
          Positioned(
            top: 4,
            left: 8,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: safeProgress),
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeOutQuint,
              builder: (context, value, child) {
                // 하이라이트 너비도 음수 방지 및 최대치 제한
                final double highlightWidth = math.max(0.0, (maxWidth - 24) * value);
                return Container(
                  height: 6,
                  width: highlightWidth,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
