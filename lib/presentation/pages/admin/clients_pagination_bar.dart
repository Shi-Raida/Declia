import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/clients_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';

class ClientsPaginationBar extends StatelessWidget {
  const ClientsPaginationBar({required this.controller, super.key});

  final ClientsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final page = controller.query.value.page;
      final pageSize = controller.query.value.pageSize;
      final total = controller.totalCount.value;
      final totalPages = controller.totalPages;

      final startIndex = page * pageSize;
      final endIndex = min(startIndex + pageSize, total);

      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: const BoxDecoration(
          color: AppColors.bgCard,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            // Affichage info
            Text(
              total > 0
                  ? 'Affichage ${startIndex + 1}–$endIndex sur $total clients'
                  : '0 clients',
              style: AppTypography.bodySmall(),
            ),
            const Spacer(),
            // Previous button
            _PageButton(
              icon: Icons.chevron_left,
              onPressed: controller.hasPreviousPage
                  ? controller.previousPage
                  : null,
            ),
            const SizedBox(width: 4),
            // Numbered page buttons (up to 5 visible)
            ..._buildPageNumbers(page, totalPages),
            const SizedBox(width: 4),
            // Next button
            _PageButton(
              icon: Icons.chevron_right,
              onPressed: controller.hasNextPage ? controller.nextPage : null,
            ),
          ],
        ),
      );
    });
  }

  List<Widget> _buildPageNumbers(int currentPage, int totalPages) {
    if (totalPages <= 1) return [];

    final maxVisible = 5;
    int start = max(0, currentPage - maxVisible ~/ 2);
    final end = min(totalPages, start + maxVisible);
    start = max(0, end - maxVisible);

    return List.generate(end - start, (i) {
      final pageNum = start + i;
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2),
        child: _NumberButton(
          pageNum: pageNum + 1,
          isActive: pageNum == currentPage,
          onPressed: () => controller.goToPage(pageNum),
        ),
      );
    });
  }
}

class _PageButton extends StatelessWidget {
  const _PageButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: IconButton(
        icon: Icon(icon, size: 18),
        onPressed: onPressed,
        color: onPressed != null ? AppColors.pierre : AppColors.border,
        padding: EdgeInsets.zero,
        style: IconButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: const BorderSide(color: AppColors.border),
          ),
        ),
      ),
    );
  }
}

class _NumberButton extends StatelessWidget {
  const _NumberButton({
    required this.pageNum,
    required this.isActive,
    required this.onPressed,
  });

  final int pageNum;
  final bool isActive;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      height: 32,
      child: TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          backgroundColor: isActive ? AppColors.bleuOuvert : Colors.transparent,
          foregroundColor: isActive ? Colors.white : AppColors.pierre,
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
            side: BorderSide(
              color: isActive ? AppColors.bleuOuvert : AppColors.border,
            ),
          ),
          minimumSize: const Size(32, 32),
        ),
        child: Text(
          '$pageNum',
          style: AppTypography.bodySmall().copyWith(
            color: isActive ? Colors.white : AppColors.pierre,
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
