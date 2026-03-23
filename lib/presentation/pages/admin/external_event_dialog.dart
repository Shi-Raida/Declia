import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/external_calendar_event.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../utils/date_formatter.dart';

class ExternalEventDialog extends StatelessWidget {
  const ExternalEventDialog({super.key, required this.event});

  final ExternalCalendarEvent event;

  @override
  Widget build(BuildContext context) {
    final hour = event.startAt.hour.toString().padLeft(2, '0');
    final minute = event.startAt.minute.toString().padLeft(2, '0');
    final endHour = event.endAt.hour.toString().padLeft(2, '0');
    final endMinute = event.endAt.minute.toString().padLeft(2, '0');

    return AlertDialog(
      title: Row(
        children: [
          const Icon(
            Icons.calendar_today,
            size: 18,
            color: AppColors.bleuOuvert,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(event.title, style: AppTypography.heading4())),
        ],
      ),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow(
              label: Tr.admin.history.colDate.tr,
              value: event.isAllDay
                  ? formatDate(event.startAt)
                  : '${formatDate(event.startAt)} $hour:$minute – $endHour:$endMinute',
            ),
            if (event.location != null && event.location!.isNotEmpty)
              _InfoRow(
                label: Tr.admin.history.colLocation.tr,
                value: event.location!,
              ),
            _InfoRow(
              label: Tr.admin.planning.externalSource.tr,
              value: Tr.admin.planning.externalEvent.tr,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            Tr.admin.clientForm.cancel.tr,
            style: AppTypography.button().copyWith(color: AppColors.pierre),
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: AppTypography.bodySmall().copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(child: Text(value, style: AppTypography.bodySmall())),
        ],
      ),
    );
  }
}
