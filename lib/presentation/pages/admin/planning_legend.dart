import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/enums/session_type.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import 'session_type_color.dart';

class PlanningLegend extends StatelessWidget {
  const PlanningLegend({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.border)),
        color: AppColors.bgCard,
      ),
      child: Wrap(
        spacing: 16,
        runSpacing: 8,
        children: [
          ...SessionType.values.map(
            (type) =>
                _LegendItem(color: type.color, label: _sessionTypeLabel(type)),
          ),
          _LegendItem(
            color: AppColors.success,
            label: Tr.planningLegendAvailable.tr,
            dashed: true,
          ),
          _LegendItem(
            color: AppColors.pierre,
            label: Tr.planningLegendBlocked.tr,
          ),
        ],
      ),
    );
  }

  String _sessionTypeLabel(SessionType type) {
    return switch (type) {
      SessionType.family => Tr.sessionTypeFamily.tr,
      SessionType.equestrian => Tr.sessionTypeEquestrian.tr,
      SessionType.event => Tr.sessionTypeEvent.tr,
      SessionType.maternity => Tr.sessionTypeMaternity.tr,
      SessionType.school => Tr.sessionTypeSchool.tr,
      SessionType.portrait => Tr.sessionTypePortrait.tr,
      SessionType.miniSession => Tr.sessionTypeMiniSession.tr,
      SessionType.other => Tr.sessionTypeOther.tr,
    };
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    this.dashed = false,
  });

  final Color color;
  final String label;
  final bool dashed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: dashed ? Colors.transparent : color,
            border: dashed ? Border.all(color: color, width: 1.5) : null,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTypography.bodySmall()),
      ],
    );
  }
}
