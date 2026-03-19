import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/communication_log.dart';
import '../../../core/enums/communication_channel.dart';
import 'history_enum_extensions.dart';
import '../../theme/app_colors.dart';
import '../../utils/date_formatter.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';

class ClientDetailCommunicationsSection extends StatelessWidget {
  const ClientDetailCommunicationsSection({
    super.key,
    required this.communicationLogs,
  });

  final List<CommunicationLog> communicationLogs;

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
          Text(
            Tr.adminHistoryCommunications.tr.toUpperCase(),
            style: AppTypography.label(),
          ),
          const SizedBox(height: 12),
          if (communicationLogs.isEmpty)
            Text(
              Tr.adminHistoryCommunicationsEmpty.tr,
              style: AppTypography.bodyMedium().copyWith(
                color: AppColors.pierre,
              ),
            )
          else
            ...communicationLogs.map((c) => _CommRow(log: c)),
        ],
      ),
    );
  }
}

class _CommRow extends StatelessWidget {
  const _CommRow({required this.log});

  final CommunicationLog log;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            log.channel == CommunicationChannel.email
                ? Icons.email_outlined
                : Icons.sms_outlined,
            size: 16,
            color: AppColors.pierre,
          ),
          const SizedBox(width: 8),
          if (log.sentAt != null) ...[
            Text(
              formatDate(log.sentAt!),
              style: AppTypography.bodySmall().copyWith(
                color: AppColors.pierre,
              ),
            ),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(log.subject ?? '—', style: AppTypography.bodyMedium()),
          ),
          const SizedBox(width: 12),
          Text(
            log.status.trKey.tr,
            style: AppTypography.bodySmall().copyWith(color: AppColors.pierre),
          ),
        ],
      ),
    );
  }
}
