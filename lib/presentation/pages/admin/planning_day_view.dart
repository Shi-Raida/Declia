import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/calendar_event.dart';
import '../../../domain/entities/external_calendar_event.dart';
import '../../../domain/entities/time_slot.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_typography.dart';
import '../../translations/translation_keys.dart';
import 'external_event_card.dart';
import 'planning_event_card.dart';

class PlanningDayView extends StatelessWidget {
  const PlanningDayView({
    super.key,
    required this.focusedDate,
    required this.events,
    required this.onEventTap,
    this.showAvailability = false,
    this.availableSlots = const [],
    this.isBlocked = false,
    this.externalEvents = const [],
    this.onExternalEventTap,
  });

  final DateTime focusedDate;
  final List<CalendarEvent> events;
  final void Function(CalendarEvent) onEventTap;
  final bool showAvailability;
  final List<TimeSlot> availableSlots;
  final bool isBlocked;
  final List<ExternalCalendarEvent> externalEvents;
  final void Function(ExternalCalendarEvent)? onExternalEventTap;

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
                  child: events.isEmpty && !showAvailability
                      ? _EmptyDay()
                      : Stack(
                          children: [
                            // Blocked overlay
                            if (showAvailability && isBlocked)
                              Positioned.fill(
                                child: Container(
                                  color: Colors.grey.withAlpha(40),
                                ),
                              ),
                            // Availability slots
                            if (showAvailability && !isBlocked)
                              for (final slot in availableSlots)
                                Positioned(
                                  top: _topOffsetFromDt(slot.start),
                                  height: _heightFromSlot(slot),
                                  left: 0,
                                  right: 0,
                                  child: Container(
                                    color: Colors.green.withAlpha(30),
                                  ),
                                ),
                            // Hour lines
                            for (int i = 0; i <= _endHour - _startHour; i++)
                              Positioned(
                                top: i * _hourHeight,
                                left: 0,
                                right: 0,
                                child: const Divider(
                                  height: 1,
                                  color: AppColors.border,
                                ),
                              ),
                            // Empty message when no events
                            if (events.isEmpty)
                              Center(
                                child: Text(
                                  Tr.adminPlanningNoSessions.tr,
                                  style: AppTypography.bodySmall(),
                                ),
                              ),
                            // External events
                            for (final ext in externalEvents)
                              Positioned(
                                top: _topOffsetFromDt(ext.startAt),
                                height: _heightFromSlot(
                                  TimeSlot(start: ext.startAt, end: ext.endAt),
                                ).clamp(_hourHeight - 8, double.infinity),
                                left: 4,
                                right: 4,
                                child: ExternalEventBlock(
                                  event: ext,
                                  onTap: () => onExternalEventTap?.call(ext),
                                  height: _heightFromSlot(
                                    TimeSlot(
                                      start: ext.startAt,
                                      end: ext.endAt,
                                    ),
                                  ).clamp(_hourHeight - 8, double.infinity),
                                ),
                              ),
                            // Events
                            for (final event in events)
                              Positioned(
                                top: _topOffset(
                                  event.session.scheduledAt,
                                  event.session.durationMinutes,
                                ),
                                left: 4,
                                right: 4,
                                child: PlanningEventBlock(
                                  event: event,
                                  onTap: () => onEventTap(event),
                                  height:
                                      (event.session.durationMinutes / 60) *
                                          _hourHeight -
                                      8,
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

  double _topOffset(DateTime scheduledAt, int durationMinutes) {
    final minutes = (scheduledAt.hour - _startHour) * 60 + scheduledAt.minute;
    final totalMinutes = (_endHour - _startHour) * 60;
    return (minutes.clamp(0, totalMinutes - durationMinutes) / 60) *
        _hourHeight;
  }

  double _topOffsetFromDt(DateTime dt) {
    final minutes = (dt.hour - _startHour) * 60 + dt.minute;
    final totalMinutes = (_endHour - _startHour) * 60;
    return (minutes.clamp(0, totalMinutes) / 60) * _hourHeight;
  }

  double _heightFromSlot(TimeSlot slot) {
    final startMinutes =
        (slot.start.hour - _startHour) * 60 + slot.start.minute;
    final endMinutes = (slot.end.hour - _startHour) * 60 + slot.end.minute;
    final totalMinutes = (_endHour - _startHour) * 60;
    final clampedStart = startMinutes.clamp(0, totalMinutes);
    final clampedEnd = endMinutes.clamp(0, totalMinutes);
    return ((clampedEnd - clampedStart) / 60) * _hourHeight;
  }
}

class _EmptyDay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        for (
          int i = 0;
          i <= PlanningDayView._endHour - PlanningDayView._startHour;
          i++
        )
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
