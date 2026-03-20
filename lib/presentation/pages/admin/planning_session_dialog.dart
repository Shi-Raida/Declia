import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/calendar_event.dart';
import '../../controllers/planning_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../utils/date_formatter.dart';
import 'history_enum_extensions.dart';

class PlanningSessionDialog extends StatelessWidget {
  const PlanningSessionDialog({super.key, required this.event});

  final CalendarEvent event;

  String _formatDuration(int minutes) {
    if (minutes < 60) return '${minutes}min';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m == 0 ? '${h}h' : '${h}h${m.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final session = event.session;
    final scheduled = session.scheduledAt;
    final hour = scheduled.hour.toString().padLeft(2, '0');
    final minute = scheduled.minute.toString().padLeft(2, '0');

    return AlertDialog(
      title: Text(
        Tr.adminPlanningSessionDetail.tr,
        style: AppTypography.heading4(),
      ),
      content: SizedBox(
        width: 360,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _InfoRow(
              label: Tr.adminHistoryColDate.tr,
              value: '${formatDate(scheduled)} $hour:$minute',
            ),
            _InfoRow(
              label: Tr.adminPlanningDuration.tr,
              value: _formatDuration(session.durationMinutes),
            ),
            _InfoRow(
              label: Tr.adminHistoryColType.tr,
              value: session.type.trKey.tr,
            ),
            _InfoRow(
              label: Tr.adminHistoryColStatus.tr,
              value: session.status.trKey.tr,
            ),
            if (session.location != null && session.location!.isNotEmpty)
              _InfoRow(
                label: Tr.adminHistoryColLocation.tr,
                value: session.location!,
              ),
            _InfoRow(
              label: Tr.adminHistoryColPayment.tr,
              value: session.paymentStatus.trKey.tr,
            ),
            _InfoRow(
              label: Tr.adminHistoryColAmount.tr,
              value: '${session.amount.toStringAsFixed(2)} €',
            ),
            const Divider(height: 24),
            Text(
              event.clientFullName,
              style: AppTypography.bodyMedium().copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            Tr.adminClientFormCancel.tr,
            style: AppTypography.button().copyWith(color: AppColors.pierre),
          ),
        ),
        FilledButton(
          onPressed: () {
            Navigator.of(context).pop();
            Get.find<PlanningController>().goToClientProfile(
              event.session.clientId,
            );
          },
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.crepuscule,
            foregroundColor: Colors.white,
          ),
          child: Text(
            Tr.adminPlanningViewClient.tr,
            style: AppTypography.button(),
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
