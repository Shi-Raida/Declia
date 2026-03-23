import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';

class QuickActionsGrid extends StatelessWidget {
  const QuickActionsGrid({super.key});

  static const _actions = [
    _QuickActionItem(
      icon: Icons.camera_alt_outlined,
      label: 'Nouvelle séance',
      route: AppRoutes.adminPlanning,
    ),
    _QuickActionItem(
      icon: Icons.photo_library_outlined,
      label: 'Créer galerie',
      route: AppRoutes.adminGalleries,
    ),
    _QuickActionItem(
      icon: Icons.person_add_outlined,
      label: 'Nouveau client',
      route: AppRoutes.adminClientNew,
    ),
    _QuickActionItem(
      icon: Icons.receipt_long_outlined,
      label: 'Nouvelle facture',
      route: AppRoutes.adminInvoicing,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          Tr.admin.dashboard.quickActions.tr,
          style: AppTypography.heading4(),
        ),
        const SizedBox(height: 12),
        Row(
          children: _actions.map((action) {
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: action == _actions.last ? 0 : 12,
                ),
                child: _QuickActionCard(item: action),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _QuickActionItem {
  const _QuickActionItem({
    required this.icon,
    required this.label,
    required this.route,
  });

  final IconData icon;
  final String label;
  final String route;
}

class _QuickActionCard extends StatelessWidget {
  const _QuickActionCard({required this.item});

  final _QuickActionItem item;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Get.toNamed(item.route),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.bleuOuvert.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, size: 22, color: AppColors.bleuOuvert),
            ),
            const SizedBox(height: 10),
            Text(
              item.label,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall().copyWith(
                color: AppColors.encre,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
