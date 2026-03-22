import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

/// Gold-label-with-line section divider matching the mockup pattern:
/// `─── IDENTITÉ ─────────────────────`
class SectionDivider extends StatelessWidget {
  const SectionDivider({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          label.toUpperCase(),
          style: AppTypography.label().copyWith(
            fontSize: 10.5,
            letterSpacing: 1.8,
            color: AppColors.or,
          ),
        ),
        const SizedBox(width: 12),
        const Expanded(child: Divider(color: AppColors.border, height: 1)),
      ],
    );
  }
}
