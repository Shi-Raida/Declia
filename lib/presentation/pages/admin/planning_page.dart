import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/enums/calendar_view.dart';
import '../../../domain/entities/calendar_event.dart';
import '../../../domain/entities/external_calendar_event.dart';
import '../../../domain/entities/time_slot.dart';
import '../../controllers/availability_controller.dart';
import '../../controllers/planning_controller.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import '../../widgets/admin/admin_layout.dart';
import 'external_event_dialog.dart';
import 'planning_day_view.dart';
import 'planning_editor_tab.dart';
import 'planning_legend.dart';
import 'planning_month_view.dart';
import 'planning_session_dialog.dart';
import 'planning_toolbar.dart';
import 'planning_week_view.dart';

class PlanningPage extends GetView<PlanningController> {
  const PlanningPage({super.key});

  AvailabilityController get availabilityController => Get.find();

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: Tr.admin.planning.title.tr,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Tab bar
          _PlanningTabBar(controller: controller),
          const Divider(height: 1, color: AppColors.border),

          // Tab content
          Expanded(
            child: Obx(
              () => switch (controller.selectedTab.value) {
                1 => PlanningEditorTab(
                  availabilityController: availabilityController,
                ),
                _ => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    PlanningToolbar(
                      controller: controller,
                      availabilityController: availabilityController,
                    ),
                    const Divider(height: 1, color: AppColors.border),
                    Expanded(
                      child: _PlanningBody(
                        controller: controller,
                        availabilityController: availabilityController,
                      ),
                    ),
                    const PlanningLegend(),
                  ],
                ),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanningTabBar extends StatelessWidget {
  const _PlanningTabBar({required this.controller});

  final PlanningController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selected = controller.selectedTab.value;
      return Container(
        color: AppColors.bgCard,
        child: Row(
          children: [
            _TabItem(
              icon: Icons.calendar_month_outlined,
              label: Tr.admin.planning.tabCalendar.tr,
              isActive: selected == 0,
              onTap: () => controller.selectedTab.value = 0,
            ),
            _TabItem(
              icon: Icons.access_time_outlined,
              label: Tr.admin.planning.tabEditor.tr,
              isActive: selected == 1,
              onTap: () => controller.selectedTab.value = 1,
            ),
          ],
        ),
      );
    });
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isActive ? AppColors.terracotta : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive ? AppColors.terracotta : AppColors.pierre,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                color: isActive ? AppColors.terracotta : AppColors.pierre,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanningBody extends StatelessWidget {
  const _PlanningBody({
    required this.controller,
    required this.availabilityController,
  });

  final PlanningController controller;
  final AvailabilityController availabilityController;

  void _showSessionDetail(BuildContext context, CalendarEvent event) {
    showDialog<void>(
      context: context,
      builder: (_) => PlanningSessionDialog(event: event),
    );
  }

  void _showExternalEventDetail(
    BuildContext context,
    ExternalCalendarEvent event,
  ) {
    showDialog<void>(
      context: context,
      builder: (_) => ExternalEventDialog(event: event),
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
      final events = controller.events.toList();
      final externalEvents = controller.externalEvents.toList();
      final showAvailability = availabilityController.showAvailability.value;

      List<TimeSlot> slotsForDate(DateTime d) => showAvailability
          ? availabilityController.availableSlotsForDate(
              d,
              events,
              externalEvents,
            )
          : [];

      bool isBlocked(DateTime d) =>
          showAvailability && availabilityController.isDateBlocked(d);

      return switch (view) {
        CalendarView.month => PlanningMonthView(
          focusedDate: date,
          events: events,
          onDayTap: controller.selectDate,
          onEventTap: (e) => _showSessionDetail(context, e),
          showAvailability: showAvailability,
          hasAvailability: (d) =>
              availabilityController.hasAvailability(d, events, externalEvents),
          isDateBlocked: availabilityController.isDateBlocked,
          externalEventsForDate: controller.externalEventsForDate,
          onExternalEventTap: (e) => _showExternalEventDetail(context, e),
        ),
        CalendarView.week => PlanningWeekView(
          focusedDate: date,
          events: events,
          onEventTap: (e) => _showSessionDetail(context, e),
          showAvailability: showAvailability,
          availableSlotsForDate: slotsForDate,
          isDateBlocked: isBlocked,
          externalEventsForDate: controller.externalEventsForDate,
          onExternalEventTap: (e) => _showExternalEventDetail(context, e),
        ),
        CalendarView.day => PlanningDayView(
          focusedDate: date,
          events: events,
          onEventTap: (e) => _showSessionDetail(context, e),
          showAvailability: showAvailability,
          availableSlots: slotsForDate(date),
          isBlocked: isBlocked(date),
          externalEvents: controller.externalEventsForDate(date),
          onExternalEventTap: (e) => _showExternalEventDetail(context, e),
        ),
      };
    });
  }
}
