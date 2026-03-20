import 'package:flutter/material.dart';

import '../../../domain/entities/calendar_event.dart';
import '../../../domain/entities/external_calendar_event.dart';
import '../../../domain/entities/time_slot.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'external_event_card.dart';
import 'planning_event_card.dart';

class PlanningWeekView extends StatelessWidget {
  const PlanningWeekView({
    super.key,
    required this.focusedDate,
    required this.events,
    required this.onEventTap,
    this.showAvailability = false,
    this.availableSlotsForDate,
    this.isDateBlocked,
    this.externalEventsForDate,
    this.onExternalEventTap,
  });

  final DateTime focusedDate;
  final List<CalendarEvent> events;
  final void Function(CalendarEvent) onEventTap;
  final bool showAvailability;
  final List<TimeSlot> Function(DateTime)? availableSlotsForDate;
  final bool Function(DateTime)? isDateBlocked;
  final List<ExternalCalendarEvent> Function(DateTime)? externalEventsForDate;
  final void Function(ExternalCalendarEvent)? onExternalEventTap;

  static const double _hourHeight = 60.0;
  static const int _startHour = 8;
  static const int _endHour = 20;
  static const double _gutterWidth = 50.0;

  @override
  Widget build(BuildContext context) {
    final monday = focusedDate.subtract(
      Duration(days: focusedDate.weekday - 1),
    );
    final days = List.generate(7, (i) => monday.add(Duration(days: i)));

    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time gutter
          const SizedBox(
            width: _gutterWidth,
            child: _TimeGutter(
              startHour: _startHour,
              endHour: _endHour,
              hourHeight: _hourHeight,
            ),
          ),
          // Day columns
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: days
                  .map(
                    (day) => Expanded(
                      child: _WeekDayColumn(
                        date: day,
                        events: _eventsForDate(day),
                        startHour: _startHour,
                        endHour: _endHour,
                        hourHeight: _hourHeight,
                        onEventTap: onEventTap,
                        availableSlots: showAvailability
                            ? (availableSlotsForDate?.call(day) ?? [])
                            : [],
                        isBlocked:
                            showAvailability &&
                            (isDateBlocked?.call(day) ?? false),
                        externalEvents: externalEventsForDate?.call(day) ?? [],
                        onExternalEventTap: onExternalEventTap,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  List<CalendarEvent> _eventsForDate(DateTime date) => events.where((e) {
    final s = e.session.scheduledAt;
    return s.year == date.year && s.month == date.month && s.day == date.day;
  }).toList();
}

class _WeekDayColumn extends StatelessWidget {
  const _WeekDayColumn({
    required this.date,
    required this.events,
    required this.startHour,
    required this.endHour,
    required this.hourHeight,
    required this.onEventTap,
    required this.availableSlots,
    required this.isBlocked,
    this.externalEvents = const [],
    this.onExternalEventTap,
  });

  final DateTime date;
  final List<CalendarEvent> events;
  final int startHour;
  final int endHour;
  final double hourHeight;
  final void Function(CalendarEvent) onEventTap;
  final List<TimeSlot> availableSlots;
  final bool isBlocked;
  final List<ExternalCalendarEvent> externalEvents;
  final void Function(ExternalCalendarEvent)? onExternalEventTap;

  bool get _isToday {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  @override
  Widget build(BuildContext context) {
    final totalHeight = (endHour - startHour) * hourHeight;

    return Column(
      children: [
        // Day header
        Container(
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            border: const Border(
              left: BorderSide(color: AppColors.border),
              bottom: BorderSide(color: AppColors.border),
            ),
            color: _isToday ? AppColors.terracottaLight : null,
          ),
          child: Column(
            children: [
              Text(
                _dayAbbrev(date.weekday),
                style: AppTypography.bodySmall().copyWith(
                  color: _isToday ? AppColors.terracotta : AppColors.pierre,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                '${date.day}',
                style: AppTypography.bodySmall().copyWith(
                  color: _isToday ? AppColors.terracotta : AppColors.encre,
                  fontWeight: _isToday ? FontWeight.w700 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        // Timeline
        SizedBox(
          height: totalHeight,
          child: Stack(
            children: [
              // Blocked overlay
              if (isBlocked)
                Positioned.fill(
                  child: Container(color: Colors.grey.withAlpha(40)),
                ),
              // Availability slots (green background)
              if (!isBlocked)
                for (final slot in availableSlots)
                  Positioned(
                    top: _topOffsetFromDt(slot.start),
                    height: _heightFromSlot(slot),
                    left: 0,
                    right: 0,
                    child: Container(color: Colors.green.withAlpha(30)),
                  ),
              // Hour lines
              for (int i = 0; i <= endHour - startHour; i++)
                Positioned(
                  top: i * hourHeight,
                  left: 0,
                  right: 0,
                  child: const Divider(height: 1, color: AppColors.border),
                ),
              // External events
              for (final ext in externalEvents)
                Positioned(
                  top: _topOffsetFromDt(ext.startAt),
                  left: 0,
                  right: 0,
                  child: ExternalEventBlock(
                    event: ext,
                    onTap: () => onExternalEventTap?.call(ext),
                    height: hourHeight - 4,
                  ),
                ),
              // Events
              for (final event in events)
                Positioned(
                  top: _topOffset(
                    event.session.scheduledAt,
                    event.session.durationMinutes,
                  ),
                  left: 0,
                  right: 0,
                  child: PlanningEventBlock(
                    event: event,
                    onTap: () => onEventTap(event),
                    height:
                        (event.session.durationMinutes / 60) * hourHeight - 4,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  double _topOffset(DateTime scheduledAt, int durationMinutes) {
    final minutes = (scheduledAt.hour - startHour) * 60 + scheduledAt.minute;
    final totalMinutes = (endHour - startHour) * 60;
    return (minutes.clamp(0, totalMinutes - durationMinutes) / 60) * hourHeight;
  }

  double _topOffsetFromDt(DateTime dt) {
    final minutes = (dt.hour - startHour) * 60 + dt.minute;
    final totalMinutes = (endHour - startHour) * 60;
    return (minutes.clamp(0, totalMinutes) / 60) * hourHeight;
  }

  double _heightFromSlot(TimeSlot slot) {
    final startMinutes = (slot.start.hour - startHour) * 60 + slot.start.minute;
    final endMinutes = (slot.end.hour - startHour) * 60 + slot.end.minute;
    final totalMinutes = (endHour - startHour) * 60;
    final clampedStart = startMinutes.clamp(0, totalMinutes);
    final clampedEnd = endMinutes.clamp(0, totalMinutes);
    return ((clampedEnd - clampedStart) / 60) * hourHeight;
  }

  String _dayAbbrev(int weekday) {
    const abbrevs = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return abbrevs[(weekday - 1) % 7];
  }
}

class _TimeGutter extends StatelessWidget {
  const _TimeGutter({
    required this.startHour,
    required this.endHour,
    required this.hourHeight,
  });

  final int startHour;
  final int endHour;
  final double hourHeight;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Spacer matching day header height
        const SizedBox(height: 50),
        for (int hour = startHour; hour <= endHour; hour++)
          SizedBox(
            height: hourHeight,
            child: Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 6, top: 2),
                child: Text(
                  '${hour.toString().padLeft(2, '0')}:00',
                  style: AppTypography.bodySmall().copyWith(fontSize: 10),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
