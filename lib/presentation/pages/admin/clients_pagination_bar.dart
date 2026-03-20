import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/clients_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';

class ClientsPaginationBar extends StatelessWidget {
  const ClientsPaginationBar({required this.controller, super.key});

  final ClientsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final page = controller.query.value.page;
      final total = controller.totalPages;
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: const BoxDecoration(
          color: AppColors.bgCard,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              onPressed: controller.hasPreviousPage
                  ? controller.previousPage
                  : null,
              color: AppColors.pierre,
            ),
            Text(
              Tr.adminClientsPaginationInfo.trParams({
                'page': '${page + 1}',
                'total': '$total',
              }),
              style: AppTypography.bodySmall(),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: controller.hasNextPage ? controller.nextPage : null,
              color: AppColors.pierre,
            ),
          ],
        ),
      );
    });
  }
}
