import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/order.dart';
import 'history_enum_extensions.dart';
import '../../theme/app_colors.dart';
import '../../utils/date_formatter.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';

class ClientDetailOrdersSection extends StatelessWidget {
  const ClientDetailOrdersSection({super.key, required this.orders});

  final List<Order> orders;

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
            Tr.adminHistoryOrders.tr.toUpperCase(),
            style: AppTypography.label(),
          ),
          const SizedBox(height: 12),
          if (orders.isEmpty)
            Text(
              Tr.adminHistoryOrdersEmpty.tr,
              style: AppTypography.bodyMedium().copyWith(
                color: AppColors.pierre,
              ),
            )
          else
            ...orders.map((o) => _OrderRow(order: o)),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            formatDate(order.orderDate),
            style: AppTypography.bodySmall().copyWith(color: AppColors.pierre),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              order.description ?? '—',
              style: AppTypography.bodyMedium(),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${order.totalAmount.toStringAsFixed(2)} €',
            style: AppTypography.bodyMedium(),
          ),
          const SizedBox(width: 12),
          Text(
            order.status.trKey.tr,
            style: AppTypography.bodySmall().copyWith(color: AppColors.pierre),
          ),
        ],
      ),
    );
  }
}
