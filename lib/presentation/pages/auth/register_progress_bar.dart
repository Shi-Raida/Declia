import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class RegisterProgressBar extends StatelessWidget {
  const RegisterProgressBar({
    required this.currentStep,
    required this.totalSteps,
    required this.accentColor,
    super.key,
  });

  final int currentStep;
  final int totalSteps;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps, (i) {
        final isDone = i < currentStep;
        final isActive = i == currentStep;

        Color color;
        if (isDone) {
          color = AppColors.success;
        } else if (isActive) {
          color = accentColor;
        } else {
          color = AppColors.border;
        }

        return Expanded(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            height: 4,
            margin: EdgeInsets.only(right: i < totalSteps - 1 ? 6 : 0),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        );
      }),
    );
  }
}
