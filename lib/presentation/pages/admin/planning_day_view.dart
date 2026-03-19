import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/calendar_event.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import 'planning_event_card.dart';

class PlanningDayView extends StatelessWidget {
  const PlanningDayView({
    super.key,
    required this.focusedDate,
    required this.events,
    required this.onEventTap,
  });

  final DateTime focusedDate;
  final List<CalendarEvent> events;
  final void Function(CalendarEvent) onEventTap;

  static const double _hourHeight = 64.0;
  static const int _startHour = 8;
  static const int _endHour = 20;
  static const double _gutterWidth = 60.0;

  @override
  Widget build(BuildContext context) {
    final totalHeight = (_endHour - _startHour) * _hourHeight;

    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time gutter
          SizedBox(
            width: _gutterWidth,
            child: Column(
              children: [
                const SizedBox(height: 8),
                for (int hour = _startHour; hour <= _endHour; hour++)
                  SizedBox(
                    height: _hourHeight,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8, top: 2),
                        child: Text(
                          '${hour.toString().padLeft(2, '0')}:00',
                          style: AppTypography.bodySmall().copyWith(
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // Day timeline
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 8),
                SizedBox(
                  height: totalHeight,
                  child: events.isEmpty
                      ? _EmptyDay()
                      : Stack(
                          children: [
                            // Hour lines
                            for (
                              int i = 0;
                              i <= _endHour - _startHour;
                              i++
                            )
                              Positioned(
                                top: i * _hourHeight,
                                left: 0,
                                right: 0,
                                child: const Divider(
                                  height: 1,
                                  color: AppColors.border,
                                ),
                              ),
                            // Events
                            for (final event in events)
                              Positioned(
                                top: _topOffset(event.session.scheduledAt),
                                left: 4,
                                right: 4,
                                child: PlanningEventBlock(
                                  event: event,
                                  onTap: () => onEventTap(event),
                                  height: _hourHeight - 8,
                                ),
                              ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  double _topOffset(DateTime scheduledAt) {
    final minutes =
        (scheduledAt.hour - _startHour) * 60 + scheduledAt.minute;
    final totalMinutes = (_endHour - _startHour) * 60;
    return (minutes.clamp(0, totalMinutes - 60) / 60) * _hourHeight;
  }
}

class _EmptyDay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (int i = 0; i <= PlanningDayView._endHour - PlanningDayView._startHour; i++)
          Positioned(
            top: i * PlanningDayView._hourHeight,
            left: 0,
            right: 0,
            child: const Divider(height: 1, color: AppColors.border),
          ),
        Center(
          child: Text(
            Tr.adminPlanningNoSessions.tr,
            style: AppTypography.bodySmall(),
          ),
        ),
      ],
    );
  }
}
