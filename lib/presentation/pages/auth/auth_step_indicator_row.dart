import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';

class AuthStepIndicatorRow extends StatelessWidget {
  const AuthStepIndicatorRow({
    required this.stepNumber,
    required this.title,
    required this.description,
    required this.isDone,
    required this.isActive,
    super.key,
  });

  final int stepNumber;
  final String title;
  final String description;
  final bool isDone;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    Color circleBg;
    Color circleContent;
    Color titleColor;
    Color descColor;

    if (isDone) {
      circleBg = AppColors.success.withValues(alpha: 0.25);
      circleContent = AppColors.success;
      titleColor = Colors.white.withValues(alpha: 0.7);
      descColor = Colors.white.withValues(alpha: 0.4);
    } else if (isActive) {
      circleBg = AppColors.or;
      circleContent = AppColors.crepuscule;
      titleColor = Colors.white;
      descColor = Colors.white.withValues(alpha: 0.6);
    } else {
      circleBg = Colors.transparent;
      circleContent = Colors.white.withValues(alpha: 0.3);
      titleColor = Colors.white.withValues(alpha: 0.3);
      descColor = Colors.white.withValues(alpha: 0.2);
    }

    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: circleBg,
            shape: BoxShape.circle,
            border: isDone || isActive
                ? null
                : Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1.5,
                  ),
          ),
          child: Center(
            child: isDone
                ? Icon(Icons.check, size: 18, color: circleContent)
                : Text(
                    '$stepNumber',
                    style: GoogleFonts.outfit(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: circleContent,
                    ),
                  ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                  color: titleColor,
                ),
                child: Text(title),
              ),
              const SizedBox(height: 2),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 300),
                style: GoogleFonts.outfit(
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                  color: descColor,
                ),
                child: Text(description),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
