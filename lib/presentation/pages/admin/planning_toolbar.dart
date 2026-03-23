import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/enums/calendar_view.dart';
import '../../controllers/availability_controller.dart';
import '../../controllers/planning_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import 'availability_rules_list_dialog.dart';

class PlanningToolbar extends StatelessWidget {
  const PlanningToolbar({
    required this.controller,
    required this.availabilityController,
    super.key,
  });

  final PlanningController controller;
  final AvailabilityController availabilityController;

  void _showRulesDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AvailabilityRulesListDialog(
        rules: availabilityController.availabilityRules,
        onAdd: availabilityController.createRule,
        onEdit: availabilityController.updateRule,
        onDelete: availabilityController.deleteRule,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // View mode toggle
            SegmentedButton<CalendarView>(
              segments: [
                ButtonSegment(
                  value: CalendarView.month,
                  label: Text(Tr.admin.planning.viewMonth.tr),
                ),
                ButtonSegment(
                  value: CalendarView.week,
                  label: Text(Tr.admin.planning.viewWeek.tr),
                ),
                ButtonSegment(
                  value: CalendarView.day,
                  label: Text(Tr.admin.planning.viewDay.tr),
                ),
              ],
              selected: {controller.currentView.value},
              onSelectionChanged: (s) => controller.setView(s.first),
              style: ButtonStyle(
                textStyle: WidgetStatePropertyAll(AppTypography.button()),
              ),
            ),
            const SizedBox(width: 16),
            // Navigation
            IconButton(
              icon: const Icon(Icons.chevron_left, size: 20),
              onPressed: controller.goToPrevious,
              style: IconButton.styleFrom(
                foregroundColor: AppColors.crepuscule,
              ),
            ),
            TextButton(
              onPressed: controller.goToToday,
              child: Text(
                Tr.admin.planning.today.tr,
                style: AppTypography.button().copyWith(
                  color: AppColors.terracotta,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right, size: 20),
              onPressed: controller.goToNext,
              style: IconButton.styleFrom(
                foregroundColor: AppColors.crepuscule,
              ),
            ),
            const SizedBox(width: 8),
            // Period label
            Text(
              controller.periodLabel(),
              style: AppTypography.bodyMedium().copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            // Availability toggle
            IconButton(
              icon: Icon(
                Icons.event_available,
                color: availabilityController.showAvailability.value
                    ? AppColors.terracotta
                    : AppColors.pierre,
              ),
              tooltip: Tr.admin.availability.toggle.tr,
              onPressed: availabilityController.toggleAvailability,
            ),
            // Manage availability rules
            IconButton(
              icon: const Icon(Icons.tune),
              tooltip: Tr.admin.availability.manage.tr,
              onPressed: () => _showRulesDialog(context),
              style: IconButton.styleFrom(
                foregroundColor: AppColors.crepuscule,
              ),
            ),
            // Loading indicator
            if (controller.isLoading.value)
              const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
          ],
        ),
      ),
    );
  }
}
