import 'package:flutter/material.dart';

import '../../../domain/entities/calendar_event.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import 'planning_event_card.dart';

class PlanningWeekView extends StatelessWidget {
  const PlanningWeekView({
    super.key,
    required this.focusedDate,
    required this.events,
    required this.onEventTap,
  });

  final DateTime focusedDate;
  final List<CalendarEvent> events;
  final void Function(CalendarEvent) onEventTap;

  static const double _hourHeight = 60.0;
  static const int _startHour = 8;
  static const int _endHour = 20;
  static const double _gutterWidth = 50.0;

  @override
  Widget build(BuildContext context) {
    final monday = focusedDate.subtract(Duration(days: focusedDate.weekday - 1));
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

  List<CalendarEvent> _eventsForDate(DateTime date) => events
      .where((e) {
        final s = e.session.scheduledAt;
        return s.year == date.year &&
            s.month == date.month &&
            s.day == date.day;
      })
      .toList();
}

class _WeekDayColumn extends StatelessWidget {
  const _WeekDayColumn({
    required this.date,
    required this.events,
    required this.startHour,
    required this.endHour,
    required this.hourHeight,
    required this.onEventTap,
  });

  final DateTime date;
  final List<CalendarEvent> events;
  final int startHour;
  final int endHour;
  final double hourHeight;
  final void Function(CalendarEvent) onEventTap;

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
                  fontWeight:
                      _isToday ? FontWeight.w700 : FontWeight.w400,
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
              // Hour lines
              for (int i = 0; i <= endHour - startHour; i++)
                Positioned(
                  top: i * hourHeight,
                  left: 0,
                  right: 0,
                  child: const Divider(height: 1, color: AppColors.border),
                ),
              // Events
              for (final event in events)
                Positioned(
                  top: _topOffset(event.session.scheduledAt),
                  left: 0,
                  right: 0,
                  child: PlanningEventBlock(
                    event: event,
                    onTap: () => onEventTap(event),
                    height: hourHeight - 4,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  double _topOffset(DateTime scheduledAt) {
    final minutes =
        (scheduledAt.hour - startHour) * 60 + scheduledAt.minute;
    final totalMinutes = (endHour - startHour) * 60;
    return (minutes.clamp(0, totalMinutes - 60) / 60) * hourHeight;
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
