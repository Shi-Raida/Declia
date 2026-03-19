import 'package:flutter/material.dart';

import '../../../domain/entities/external_calendar_event.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

/// Compact pill for external Google Calendar events in the month grid.
class ExternalEventPill extends StatelessWidget {
  const ExternalEventPill({
    super.key,
    required this.event,
    required this.onTap,
  });

  final ExternalCalendarEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 1),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
        decoration: BoxDecoration(
          color: AppColors.bleuOuvertLight,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(color: AppColors.bleuOuvert.withValues(alpha: 0.4)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_today, size: 8, color: AppColors.bleuOuvert),
            const SizedBox(width: 2),
            Flexible(
              child: Text(
                event.title,
                style: AppTypography.bodySmall().copyWith(
                  fontSize: 10,
                  color: AppColors.bleuOuvert,
                  height: 1.3,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Full block for external events in the week/day timeline.
class ExternalEventBlock extends StatelessWidget {
  const ExternalEventBlock({
    super.key,
    required this.event,
    required this.onTap,
    this.height = 56,
  });

  final ExternalCalendarEvent event;
  final VoidCallback onTap;
  final double height;

  @override
  Widget build(BuildContext context) {
    final hour = event.startAt.hour.toString().padLeft(2, '0');
    final minute = event.startAt.minute.toString().padLeft(2, '0');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.bleuOuvertLight,
          borderRadius: BorderRadius.circular(4),
          border: const Border(
            left: BorderSide(color: AppColors.bleuOuvert, width: 3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$hour:$minute',
              style: AppTypography.bodySmall().copyWith(
                fontSize: 10,
                color: AppColors.bleuOuvert,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              event.title,
              style: AppTypography.bodySmall().copyWith(
                fontSize: 11,
                color: AppColors.encre,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (height >= 56 && event.location != null)
              Text(
                event.location!,
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
