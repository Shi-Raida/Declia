import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class DetailSection extends StatelessWidget {
  const DetailSection({super.key, required this.title, required this.rows});

  final String title;
  final List<DetailRow> rows;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title.toUpperCase(), style: AppTypography.label()),
          const SizedBox(height: 12),
          ...rows,
        ],
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  const DetailRow({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              label,
              style: AppTypography.bodySmall().copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.pierre,
              ),
            ),
          ),
          Expanded(child: Text(value, style: AppTypography.bodyMedium())),
        ],
      ),
    );
  }
}
