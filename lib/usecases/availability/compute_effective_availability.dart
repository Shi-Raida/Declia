import '../../core/enums/availability_rule_type.dart';
import '../../domain/entities/availability_rule.dart';
import '../../domain/entities/calendar_event.dart';
import '../../domain/entities/external_calendar_event.dart';
import '../../domain/entities/time_slot.dart';

/// Pure function: computes effective available [TimeSlot]s for a given [date],
/// taking into account availability [rules] and booked [sessions].
///
/// Logic:
/// 1. If a `blocked` rule exists for [date], return empty (day is blocked).
/// 2. Collect base slots from `recurring` rules matching [date]'s weekday.
/// 3. Apply `override` rules for [date]: replace recurring slots entirely.
/// 4. Subtract session times from the resulting slots.
List<TimeSlot> computeEffectiveAvailability(
  List<AvailabilityRule> rules,
  List<CalendarEvent> sessions,
  DateTime date, {
  List<ExternalCalendarEvent> externalEvents = const [],
}) {
  final dateOnly = DateTime(date.year, date.month, date.day);

  // Step 1: check for blocked rule
  final isBlocked = rules.any(
    (r) =>
        r.ruleType == AvailabilityRuleType.blocked &&
        r.specificDate != null &&
        _sameDay(r.specificDate!, dateOnly),
  );
  if (isBlocked) return [];

  // Step 2: base slots from recurring rules (day_of_week: 1=Mon..7=Sun in DateTime)
  final recurringSlots = rules
      .where(
        (r) =>
            r.ruleType == AvailabilityRuleType.recurring &&
            r.dayOfWeek != null &&
            r.dayOfWeek == date.weekday &&
            r.startTime != null &&
            r.endTime != null,
      )
      .map((r) => _ruleToSlot(r, dateOnly))
      .whereType<TimeSlot>()
      .toList();

  // Step 3: override rules for this specific date
  final overrideSlots = rules
      .where(
        (r) =>
            r.ruleType == AvailabilityRuleType.override &&
            r.specificDate != null &&
            _sameDay(r.specificDate!, dateOnly) &&
            r.startTime != null &&
            r.endTime != null,
      )
      .map((r) => _ruleToSlot(r, dateOnly))
      .whereType<TimeSlot>()
      .toList();

  final baseSlots = overrideSlots.isNotEmpty ? overrideSlots : recurringSlots;
  if (baseSlots.isEmpty) return [];

  // Step 4: subtract session times
  final daySessionSlots = sessions
      .where((e) {
        final s = e.session.scheduledAt;
        return s.year == date.year &&
            s.month == date.month &&
            s.day == date.day;
      })
      .map((e) {
        final start = e.session.scheduledAt;
        final end = start.add(Duration(minutes: e.session.durationMinutes));
        return TimeSlot(start: start, end: end);
      })
      .toList();

  var result = baseSlots;
  for (final session in daySessionSlots) {
    result = result.expand((slot) => _subtractSlot(slot, session)).toList();
  }

  // Step 5: subtract external calendar event times
  final dayExternalSlots = externalEvents
      .where((e) {
        if (e.isAllDay) {
          return _sameDay(e.startAt, date) ||
              (e.startAt.isBefore(dateOnly) && e.endAt.isAfter(dateOnly));
        }
        return _sameDay(e.startAt, date);
      })
      .map((e) {
        if (e.isAllDay) {
          return TimeSlot(
            start: DateTime(date.year, date.month, date.day, 0, 0),
            end: DateTime(date.year, date.month, date.day, 23, 59, 59),
          );
        }
        return TimeSlot(start: e.startAt, end: e.endAt);
      })
      .toList();

  for (final extSlot in dayExternalSlots) {
    result = result.expand((slot) => _subtractSlot(slot, extSlot)).toList();
  }

  return result;
}

bool _sameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

TimeSlot? _ruleToSlot(AvailabilityRule rule, DateTime dateOnly) {
  final start = _parseTime(rule.startTime, dateOnly);
  final end = _parseTime(rule.endTime, dateOnly);
  if (start == null || end == null) return null;
  return TimeSlot(start: start, end: end);
}

/// Parses a Postgres TIME string (HH:MM:SS or HH:MM) into a DateTime on [date].
DateTime? _parseTime(String? timeStr, DateTime date) {
  if (timeStr == null) return null;
  final parts = timeStr.split(':');
  if (parts.length < 2) return null;
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return null;
  return DateTime(date.year, date.month, date.day, hour, minute);
}

/// Returns [slot] minus the [toRemove] interval (may split into 0-2 sub-slots).
List<TimeSlot> _subtractSlot(TimeSlot slot, TimeSlot toRemove) {
  // No overlap
  if (toRemove.end.isBefore(slot.start) || !toRemove.start.isBefore(slot.end)) {
    return [slot];
  }
  final result = <TimeSlot>[];
  if (slot.start.isBefore(toRemove.start)) {
    result.add(TimeSlot(start: slot.start, end: toRemove.start));
  }
  if (toRemove.end.isBefore(slot.end)) {
    result.add(TimeSlot(start: toRemove.end, end: slot.end));
  }
  return result;
}
