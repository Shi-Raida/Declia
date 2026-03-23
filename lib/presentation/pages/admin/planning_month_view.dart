import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/calendar_event.dart';
import '../../../domain/entities/external_calendar_event.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import 'external_event_card.dart';
import 'planning_event_card.dart';

class PlanningMonthView extends StatelessWidget {
  const PlanningMonthView({
    super.key,
    required this.focusedDate,
    required this.events,
    required this.onDayTap,
    required this.onEventTap,
    this.showAvailability = false,
    this.hasAvailability,
    this.isDateBlocked,
    this.externalEventsForDate,
    this.onExternalEventTap,
  });

  final DateTime focusedDate;
  final List<CalendarEvent> events;
  final void Function(DateTime) onDayTap;
  final void Function(CalendarEvent) onEventTap;
  final bool showAvailability;
  final bool Function(DateTime)? hasAvailability;
  final bool Function(DateTime)? isDateBlocked;
  final List<ExternalCalendarEvent> Function(DateTime)? externalEventsForDate;
  final void Function(ExternalCalendarEvent)? onExternalEventTap;

  static final _dayHeaders = [
    Tr.admin.planning.monday,
    Tr.admin.planning.tuesday,
    Tr.admin.planning.wednesday,
    Tr.admin.planning.thursday,
    Tr.admin.planning.friday,
    Tr.admin.planning.saturday,
    Tr.admin.planning.sunday,
  ];

  @override
  Widget build(BuildContext context) {
    final gridStart = _computeGridStart(focusedDate);
    final rowCount = _computeRowCount(focusedDate);

    return Column(
      children: [
        // Day headers
        Row(
          children: [
            for (final key in _dayHeaders)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: const BoxDecoration(
                    border: Border(bottom: BorderSide(color: AppColors.border)),
                  ),
                  child: Text(
                    key.tr,
                    textAlign: TextAlign.center,
                    style: AppTypography.bodySmall().copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.pierre,
                    ),
                  ),
                ),
              ),
          ],
        ),
        // Day grid
        Expanded(
          child: Column(
            children: [
              for (int row = 0; row < rowCount; row++)
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (int col = 0; col < 7; col++)
                        Expanded(
                          child: _DayCell(
                            date: gridStart.add(Duration(days: row * 7 + col)),
                            focusedMonth: focusedDate.month,
                            events: _eventsForDate(
                              gridStart.add(Duration(days: row * 7 + col)),
                            ),
                            onDayTap: onDayTap,
                            onEventTap: onEventTap,
                            showAvailability: showAvailability,
                            hasAvailability: hasAvailability,
                            isDateBlocked: isDateBlocked,
                            externalEvents:
                                externalEventsForDate?.call(
                                  gridStart.add(Duration(days: row * 7 + col)),
                                ) ??
                                [],
                            onExternalEventTap: onExternalEventTap,
                          ),
                        ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  DateTime _computeGridStart(DateTime date) {
    final first = DateTime(date.year, date.month);
    return first.subtract(Duration(days: first.weekday - 1));
  }

  int _computeRowCount(DateTime date) {
    final first = DateTime(date.year, date.month);
    final last = DateTime(date.year, date.month + 1, 0);
    final totalDays = (first.weekday - 1) + last.day;
    return (totalDays / 7).ceil();
  }

  List<CalendarEvent> _eventsForDate(DateTime date) => events.where((e) {
    final s = e.session.scheduledAt;
    return s.year == date.year && s.month == date.month && s.day == date.day;
  }).toList();
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.date,
    required this.focusedMonth,
    required this.events,
    required this.onDayTap,
    required this.onEventTap,
    required this.showAvailability,
    this.hasAvailability,
    this.isDateBlocked,
    this.externalEvents = const [],
    this.onExternalEventTap,
  });

  final DateTime date;
  final int focusedMonth;
  final List<CalendarEvent> events;
  final void Function(DateTime) onDayTap;
  final void Function(CalendarEvent) onEventTap;
  final bool showAvailability;
  final bool Function(DateTime)? hasAvailability;
  final bool Function(DateTime)? isDateBlocked;
  final List<ExternalCalendarEvent> externalEvents;
  final void Function(ExternalCalendarEvent)? onExternalEventTap;

  bool get _isCurrentMonth => date.month == focusedMonth;

  bool get _isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    const maxVisible = 3;
    final visible = events.take(maxVisible).toList();
    final overflow = events.length - maxVisible;

    final blocked = showAvailability && (isDateBlocked?.call(date) ?? false);
    final hasSlots =
        showAvailability && !blocked && (hasAvailability?.call(date) ?? false);

    return GestureDetector(
      onTap: () => onDayTap(date),
      child: Container(
        decoration: BoxDecoration(
          border: const Border(
            right: BorderSide(color: AppColors.border),
            bottom: BorderSide(color: AppColors.border),
          ),
          color: blocked
              ? Colors.grey.withAlpha(25)
              : _isCurrentMonth
              ? null
              : AppColors.bg,
        ),
        padding: const EdgeInsets.all(4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Day number row with optional availability dot
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Availability dot
                if (showAvailability)
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: blocked
                          ? AppColors.pierre
                          : hasSlots
                          ? Colors.green
                          : Colors.transparent,
                    ),
                  )
                else
                  const SizedBox(width: 6),
                // Day number
                Container(
                  width: 24,
                  height: 24,
                  decoration: _isToday
                      ? const BoxDecoration(
                          color: AppColors.terracotta,
                          shape: BoxShape.circle,
                        )
                      : null,
                  child: Center(
                    child: Text(
                      '${date.day}',
                      style: AppTypography.bodySmall().copyWith(
                        fontWeight: _isToday
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: _isToday
                            ? Colors.white
                            : _isCurrentMonth
                            ? AppColors.encre
                            : AppColors.pierre,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            // External event pills
            for (final ext in externalEvents.take(2))
              ExternalEventPill(
                event: ext,
                onTap: () => onExternalEventTap?.call(ext),
              ),
            // Declia session pills
            for (final event in visible)
              PlanningEventPill(event: event, onTap: () => onEventTap(event)),
            // Overflow indicator
            if (overflow > 0)
              Text(
                '+$overflow',
                style: AppTypography.bodySmall().copyWith(
                  fontSize: 10,
                  color: AppColors.pierre,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
