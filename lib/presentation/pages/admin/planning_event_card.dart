import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/calendar_event.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'history_enum_extensions.dart';
import 'session_type_color.dart';

/// Compact dot/pill used in month grid cells.
class PlanningEventDot extends StatelessWidget {
  const PlanningEventDot({super.key, required this.event});

  final CalendarEvent event;

  @override
  Widget build(BuildContext context) {
    final color = event.session.type.color;
    return Container(
      height: 6,
      width: 6,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

/// Compact pill used in month grid cells (shows label).
class PlanningEventPill extends StatelessWidget {
  const PlanningEventPill({
    super.key,
    required this.event,
    required this.onTap,
  });

  final CalendarEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = event.session.type.color;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 1),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Text(
          event.clientFullName,
          style: AppTypography.bodySmall().copyWith(
            fontSize: 10,
            color: color,
            height: 1.3,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}

/// Full block used in week/day timeline views.
class PlanningEventBlock extends StatelessWidget {
  const PlanningEventBlock({
    super.key,
    required this.event,
    required this.onTap,
    this.height = 56,
  });

  final CalendarEvent event;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    final color = event.session.type.color;
    final scheduled = event.session.scheduledAt;
    final hour = scheduled.hour.toString().padLeft(2, '0');
    final minute = scheduled.minute.toString().padLeft(2, '0');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(4),
          border: Border(left: BorderSide(color: color, width: 3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$hour:$minute',
              style: AppTypography.bodySmall().copyWith(
                fontSize: 10,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              event.clientFullName,
              style: AppTypography.bodySmall().copyWith(
                fontSize: 11,
                color: AppColors.encre,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (height >= 56)
              Text(
                event.session.type.trKey.tr,
                style: AppTypography.bodySmall().copyWith(
                  fontSize: 10,
                  color: AppColors.pierre,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    );
  }
}
