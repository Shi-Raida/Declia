import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/session.dart';
import 'history_enum_extensions.dart';
import '../../theme/app_colors.dart';
import '../../utils/date_formatter.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';

class ClientDetailSessionsSection extends StatelessWidget {
  const ClientDetailSessionsSection({super.key, required this.sessions});

  final List<Session> sessions;

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
            Tr.admin.history.sessions.tr.toUpperCase(),
            style: AppTypography.label(),
          ),
          const SizedBox(height: 12),
          if (sessions.isEmpty)
            Text(
              Tr.admin.history.sessionsEmpty.tr,
              style: AppTypography.bodyMedium().copyWith(
                color: AppColors.pierre,
              ),
            )
          else
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingTextStyle: AppTypography.bodySmall().copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.pierre,
                ),
                dataTextStyle: AppTypography.bodyMedium(),
                columns: [
                  DataColumn(label: Text(Tr.admin.history.colDate.tr)),
                  DataColumn(label: Text(Tr.admin.history.colType.tr)),
                  DataColumn(label: Text(Tr.admin.history.colLocation.tr)),
                  DataColumn(label: Text(Tr.admin.history.colStatus.tr)),
                  DataColumn(label: Text(Tr.admin.history.colPayment.tr)),
                  DataColumn(
                    label: Text(Tr.admin.history.colAmount.tr),
                    numeric: true,
                  ),
                ],
                rows: sessions.map((s) => _buildRow(s)).toList(),
              ),
            ),
        ],
      ),
    );
  }

  DataRow _buildRow(Session s) {
    return DataRow(
      cells: [
        DataCell(Text(formatDate(s.scheduledAt))),
        DataCell(Text(s.type.trKey.tr)),
        DataCell(Text(s.location ?? '—')),
        DataCell(Text(s.status.trKey.tr)),
        DataCell(Text(s.paymentStatus.trKey.tr)),
        DataCell(Text('${s.amount.toStringAsFixed(2)} €')),
      ],
    );
  }
}
