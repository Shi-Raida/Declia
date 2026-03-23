import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../domain/entities/availability_rule.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class WeeklySummary extends StatelessWidget {
  const WeeklySummary({super.key, required this.rules});

  final List<AvailabilityRule> rules;

  static const _dayNames = ['Lun', 'Mar', 'Mer', 'Jeu', 'Ven', 'Sam', 'Dim'];

  int _countMinutes(int weekday) {
    int total = 0;
    for (final rule in rules) {
      if (rule.dayOfWeek != weekday) continue;
      final start = _parseTime(rule.startTime);
      final end = _parseTime(rule.endTime);
      if (start != null && end != null && end > start) {
        total += end - start;
      }
    }
    return total;
  }

  static int? _parseTime(String? time) {
    if (time == null) return null;
    final parts = time.split(':');
    if (parts.length < 2) return null;
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(7, (i) {
        final minutes = _countMinutes(i + 1);
        final hours = minutes ~/ 60;
        final mins = minutes % 60;
        final label = minutes > 0
            ? (mins > 0 ? '${hours}h$mins' : '${hours}h')
            : '—';
        final hasAny = minutes > 0;

        return Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: hasAny
                  ? AppColors.success.withValues(alpha: 0.08)
                  : AppColors.bgAlt,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: hasAny
                    ? AppColors.success.withValues(alpha: 0.3)
                    : AppColors.border,
              ),
            ),
            child: Column(
              children: [
                Text(
                  _dayNames[i],
                  style: AppTypography.sectionTitle(),
                  textAlign: TextAlign.center,
                ),
                Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: hasAny ? AppColors.success : AppColors.pierre,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
