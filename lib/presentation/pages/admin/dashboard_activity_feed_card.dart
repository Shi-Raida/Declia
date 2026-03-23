import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';

class ActivityFeedCard extends StatelessWidget {
  const ActivityFeedCard({super.key});

  static const _activities = [
    _ActivityItem(
      color: AppColors.success,
      text: 'Nouvelle commande #CMD-024',
      time: 'Il y a 2h',
    ),
    _ActivityItem(
      color: AppColors.bleuOuvert,
      text: 'Client Martin Sophie a validé sa galerie',
      time: 'Il y a 4h',
    ),
    _ActivityItem(
      color: AppColors.or,
      text: 'Nouveau client ajouté',
      time: 'Il y a 6h',
    ),
    _ActivityItem(
      color: AppColors.terracotta,
      text: 'Facture #INV-042 créée',
      time: 'Hier',
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
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 16, 12),
            child: Text(
              Tr.admin.dashboard.recentActivity.tr,
              style: AppTypography.heading4(),
            ),
          ),
          const Divider(height: 1, color: AppColors.border),
          ..._activities.map((a) => _ActivityRow(item: a)),
        ],
      ),
    );
  }
}

class _ActivityItem {
  const _ActivityItem({
    required this.color,
    required this.text,
    required this.time,
  });

  final Color color;
  final String text;
  final String time;
}

class _ActivityRow extends StatelessWidget {
  const _ActivityRow({required this.item});

  final _ActivityItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: item.color,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.text,
                  style: AppTypography.bodySmall().copyWith(
                    color: AppColors.encre,
                  ),
                ),
                const SizedBox(height: 2),
                Text(item.time, style: AppTypography.bodySmall()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
