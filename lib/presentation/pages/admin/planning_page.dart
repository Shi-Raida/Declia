import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/enums/calendar_view.dart';
import '../../../domain/entities/calendar_event.dart';
import '../../../domain/entities/time_slot.dart';
import '../../controllers/planning_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/admin/admin_layout.dart';
import 'availability_rules_list_dialog.dart';
import 'planning_day_view.dart';
import 'planning_month_view.dart';
import 'planning_session_dialog.dart';
import 'planning_week_view.dart';

class PlanningPage extends GetView<PlanningController> {
  const PlanningPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: Tr.adminPlanningTitle.tr,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _PlanningToolbar(controller: controller),
          const Divider(height: 1, color: AppColors.border),
          Expanded(child: _PlanningBody(controller: controller)),
        ],
      ),
    );
  }
}

class _PlanningToolbar extends StatelessWidget {
  const _PlanningToolbar({required this.controller});

  final PlanningController controller;

  void _showRulesDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => AvailabilityRulesListDialog(
        rules: controller.availabilityRules,
        onAdd: controller.createRule,
        onEdit: controller.updateRule,
        onDelete: controller.deleteRule,
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
                  label: Text(Tr.adminPlanningViewMonth.tr),
                ),
                ButtonSegment(
                  value: CalendarView.week,
                  label: Text(Tr.adminPlanningViewWeek.tr),
                ),
                ButtonSegment(
                  value: CalendarView.day,
                  label: Text(Tr.adminPlanningViewDay.tr),
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
                Tr.adminPlanningToday.tr,
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
                color: controller.showAvailability.value
                    ? AppColors.terracotta
                    : AppColors.pierre,
              ),
              tooltip: Tr.adminAvailabilityToggle.tr,
              onPressed: controller.toggleAvailability,
            ),
            // Manage availability rules
            IconButton(
              icon: const Icon(Icons.tune),
              tooltip: Tr.adminAvailabilityManage.tr,
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

class _PlanningBody extends StatelessWidget {
  const _PlanningBody({required this.controller});

  final PlanningController controller;

  void _showSessionDetail(BuildContext context, CalendarEvent event) {
    showDialog<void>(
      context: context,
      builder: (_) => PlanningSessionDialog(event: event),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.errorMessage.value != null) {
        return Center(
          child: Text(
            controller.errorMessage.value!,
            style: AppTypography.bodyMedium().copyWith(color: AppColors.error),
          ),
        );
      }

      final view = controller.currentView.value;
      final date = controller.focusedDate.value;
      final events = controller.events;
      final showAvailability = controller.showAvailability.value;

      List<TimeSlot> slotsForDate(DateTime d) =>
          showAvailability ? controller.availableSlotsForDate(d) : [];

      bool isBlocked(DateTime d) =>
          showAvailability && controller.isDateBlocked(d);

      return switch (view) {
        CalendarView.month => PlanningMonthView(
          focusedDate: date,
          events: events,
          onDayTap: controller.selectDate,
          onEventTap: (e) => _showSessionDetail(context, e),
          showAvailability: showAvailability,
          hasAvailability: controller.hasAvailability,
          isDateBlocked: controller.isDateBlocked,
        ),
        CalendarView.week => PlanningWeekView(
          focusedDate: date,
          events: events,
          onEventTap: (e) => _showSessionDetail(context, e),
          showAvailability: showAvailability,
          availableSlotsForDate: slotsForDate,
          isDateBlocked: isBlocked,
        ),
        CalendarView.day => PlanningDayView(
          focusedDate: date,
          events: events,
          onEventTap: (e) => _showSessionDetail(context, e),
          showAvailability: showAvailability,
          availableSlots: slotsForDate(date),
          isBlocked: isBlocked(date),
        ),
      };
    });
  }
}
