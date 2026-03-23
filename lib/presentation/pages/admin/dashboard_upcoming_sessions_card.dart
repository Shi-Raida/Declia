import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/enums/session_type.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/admin/session_type_tag.dart';
import 'session_type_color.dart';

class UpcomingSessionsCard extends StatelessWidget {
  const UpcomingSessionsCard({super.key});

  // Placeholder data
  static const _items = [
    _SessionPlaceholder(
      date: 'Mar 22',
      time: '10:00',
      client: 'Martin Sophie',
      type: SessionType.family,
    ),
    _SessionPlaceholder(
      date: 'Mar 23',
      time: '14:30',
      client: 'Dubois Marie',
      type: SessionType.maternity,
    ),
    _SessionPlaceholder(
      date: 'Mar 25',
      time: '09:00',
      client: 'Laurent Thomas',
      type: SessionType.portrait,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
            child: Row(
              children: [
                Text(
                  Tr.admin.dashboard.upcomingSessions.tr,
                  style: AppTypography.heading4(),
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Get.toNamed(AppRoutes.adminPlanning),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.bleuOuvert,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    Tr.admin.dashboard.seeAll.tr,
                    style: AppTypography.bodySmall().copyWith(
                      color: AppColors.bleuOuvert,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          ..._items.map((item) => _SessionItemRow(item: item)),
        ],
      ),
    );
  }
}

class _SessionPlaceholder {
  const _SessionPlaceholder({
    required this.date,
    required this.time,
    required this.client,
    required this.type,
  });

  final String date;
  final String time;
  final String client;
  final SessionType type;
}

class _SessionItemRow extends StatelessWidget {
  const _SessionItemRow({required this.item});

  final _SessionPlaceholder item;

  @override
  Widget build(BuildContext context) {
    final color = item.type.color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          // Date block
          Container(
            width: 52,
            padding: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.bg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(
                  item.date.split(' ').last,
                  style: AppTypography.statValue().copyWith(fontSize: 20),
                ),
                Text(
                  item.date.split(' ').first,
                  style: AppTypography.sectionTitle(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.client,
                  style: AppTypography.bodyMedium().copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.access_time,
                      size: 12,
                      color: AppColors.pierre,
                    ),
                    const SizedBox(width: 4),
                    Text(item.time, style: AppTypography.bodySmall()),
                  ],
                ),
              ],
            ),
          ),
          SessionTypeTag(label: item.type.name, color: color),
        ],
      ),
    );
  }
}
