import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../utils/date_formatter.dart';
import '../../../domain/entities/client_history.dart';

class ClientDetailStatsCard extends StatelessWidget {
  const ClientDetailStatsCard({super.key, required this.history});

  final ClientHistory history;

  @override
  Widget build(BuildContext context) {
    final totalSpent = history.totalSpent;
    final lastShooting = history.lastShooting;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.border),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          _StatCell(
            label: Tr.adminHistoryStatSessions.tr,
            value: history.sessionCount.toString(),
          ),
          _StatDivider(),
          _StatCell(
            label: Tr.adminHistoryStatTotalSpent.tr,
            value: '${totalSpent.toStringAsFixed(2)} €',
          ),
          _StatDivider(),
          _StatCell(
            label: Tr.adminHistoryStatLastShooting.tr,
            value: lastShooting != null ? formatDate(lastShooting) : '—',
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            value,
            style: AppTypography.heading4(),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTypography.bodySmall().copyWith(color: AppColors.pierre),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _StatDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 1,
      color: AppColors.border,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }
}
