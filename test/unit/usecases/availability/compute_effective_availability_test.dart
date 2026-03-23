import 'package:declia/core/enums/availability_rule_type.dart';
import 'package:declia/core/enums/payment_status.dart';
import 'package:declia/core/enums/session_status.dart';
import 'package:declia/core/enums/session_type.dart';
import 'package:declia/domain/entities/availability_rule.dart';
import 'package:declia/domain/entities/calendar_event.dart';
import 'package:declia/domain/entities/external_calendar_event.dart';
import 'package:declia/domain/entities/session.dart';
import 'package:declia/domain/services/compute_effective_availability.dart';
import 'package:flutter_test/flutter_test.dart';

// Wednesday 2026-03-18 (weekday = 3)
final _wednesday = DateTime(2026, 3, 18);

// Thursday 2026-03-19 (weekday = 4)
final _thursday = DateTime(2026, 3, 19);

AvailabilityRule _recurring({
  int dayOfWeek = 3,
  String start = '09:00:00',
  String end = '18:00:00',
}) => AvailabilityRule(
  id: 'r1',
  tenantId: 'tid',
  ruleType: AvailabilityRuleType.recurring,
  dayOfWeek: dayOfWeek,
  startTime: start,
  endTime: end,
  createdAt: _wednesday,
  updatedAt: _wednesday,
);

AvailabilityRule _override({
  DateTime? date,
  String start = '10:00:00',
  String end = '14:00:00',
}) => AvailabilityRule(
  id: 'r2',
  tenantId: 'tid',
  ruleType: AvailabilityRuleType.override,
  specificDate: date ?? _wednesday,
  startTime: start,
  endTime: end,
  createdAt: _wednesday,
  updatedAt: _wednesday,
);

AvailabilityRule _blocked({DateTime? date}) => AvailabilityRule(
  id: 'r3',
  tenantId: 'tid',
  ruleType: AvailabilityRuleType.blocked,
  specificDate: date ?? _wednesday,
  createdAt: _wednesday,
  updatedAt: _wednesday,
);

CalendarEvent _session(DateTime scheduledAt) => CalendarEvent(
  session: Session(
    id: 's1',
    tenantId: 'tid',
    clientId: 'cid',
    type: SessionType.portrait,
    status: SessionStatus.scheduled,
    scheduledAt: scheduledAt,
    paymentStatus: PaymentStatus.pending,
    amount: 150.0,
    createdAt: _wednesday,
    updatedAt: _wednesday,
  ),
  clientFirstName: 'Alice',
  clientLastName: 'Dupont',
);

void main() {
  group('computeEffectiveAvailability', () {
    group('recurring rules', () {
      test('returns slot when recurring rule matches weekday', () {
        final rules = [_recurring(dayOfWeek: 3)]; // Wednesday

        final slots = computeEffectiveAvailability(rules, [], _wednesday);

        expect(slots.length, 1);
        expect(slots.first.start, DateTime(2026, 3, 18, 9, 0));
        expect(slots.first.end, DateTime(2026, 3, 18, 18, 0));
      });

      test('returns empty when recurring rule does not match weekday', () {
        final rules = [_recurring(dayOfWeek: 3)]; // Wednesday only

        final slots = computeEffectiveAvailability(rules, [], _thursday);

        expect(slots, isEmpty);
      });

      test('returns empty when no rules defined', () {
        final slots = computeEffectiveAvailability([], [], _wednesday);

        expect(slots, isEmpty);
      });
    });

    group('blocked rules', () {
      test('returns empty when date is blocked', () {
        final rules = [_recurring(dayOfWeek: 3), _blocked()];

        final slots = computeEffectiveAvailability(rules, [], _wednesday);

        expect(slots, isEmpty);
      });

      test('blocked rule does not affect other dates', () {
        final rules = [_recurring(dayOfWeek: 3), _blocked()];
        // A different Wednesday (not the same date as the blocked one)
        final otherWed = DateTime(2026, 3, 25);

        final slots = computeEffectiveAvailability(rules, [], otherWed);

        expect(slots.length, 1);
      });
    });

    group('override rules', () {
      test('override replaces recurring slot for specific date', () {
        final rules = [
          _recurring(dayOfWeek: 3, start: '09:00:00', end: '18:00:00'),
          _override(start: '10:00:00', end: '14:00:00'),
        ];

        final slots = computeEffectiveAvailability(rules, [], _wednesday);

        // Override replaces recurring
        expect(slots.length, 1);
        expect(slots.first.start, DateTime(2026, 3, 18, 10, 0));
        expect(slots.first.end, DateTime(2026, 3, 18, 14, 0));
      });

      test('override on different date does not affect target date', () {
        final tomorrow = DateTime(2026, 3, 19);
        final rules = [
          _recurring(dayOfWeek: 3, start: '09:00:00', end: '18:00:00'),
          _override(date: tomorrow, start: '10:00:00', end: '14:00:00'),
        ];

        final slots = computeEffectiveAvailability(rules, [], _wednesday);

        // Original recurring slot should be returned
        expect(slots.length, 1);
        expect(slots.first.start, DateTime(2026, 3, 18, 9, 0));
      });
    });

    group('session subtraction', () {
      test('session removes its time from available slot', () {
        final rules = [
          _recurring(dayOfWeek: 3, start: '09:00:00', end: '18:00:00'),
        ];
        // Session at 11:00 on Wednesday
        final sessionAt = DateTime(2026, 3, 18, 11, 0);
        final sessions = [_session(sessionAt)];

        final slots = computeEffectiveAvailability(rules, sessions, _wednesday);

        // Should be split into [09:00-11:00] and [12:00-18:00]
        expect(slots.length, 2);
        expect(slots[0].start, DateTime(2026, 3, 18, 9, 0));
        expect(slots[0].end, DateTime(2026, 3, 18, 11, 0));
        expect(slots[1].start, DateTime(2026, 3, 18, 12, 0));
        expect(slots[1].end, DateTime(2026, 3, 18, 18, 0));
      });

      test('session on different date does not affect slot', () {
        final rules = [
          _recurring(dayOfWeek: 3, start: '09:00:00', end: '18:00:00'),
        ];
        // Session on Thursday, not Wednesday
        final sessionAt = DateTime(2026, 3, 19, 11, 0);
        final sessions = [_session(sessionAt)];

        final slots = computeEffectiveAvailability(rules, sessions, _wednesday);

        expect(slots.length, 1);
        expect(slots.first.start, DateTime(2026, 3, 18, 9, 0));
        expect(slots.first.end, DateTime(2026, 3, 18, 18, 0));
      });

      test('multiple sessions carve multiple sub-slots', () {
        final rules = [
          _recurring(dayOfWeek: 3, start: '09:00:00', end: '18:00:00'),
        ];
        final sessions = [
          _session(DateTime(2026, 3, 18, 10, 0)),
          _session(DateTime(2026, 3, 18, 14, 0)),
        ];

        final slots = computeEffectiveAvailability(rules, sessions, _wednesday);

        // 09-10, 11-14, 15-18
        expect(slots.length, 3);
      });
    });

    group('combined scenarios', () {
      test('blocked day beats override and recurring', () {
        final rules = [_recurring(dayOfWeek: 3), _override(), _blocked()];

        final slots = computeEffectiveAvailability(rules, [], _wednesday);

        expect(slots, isEmpty);
      });
    });

    group('session duration', () {
      test('30-minute session carves correct window', () {
        final rules = [
          _recurring(dayOfWeek: 3, start: '09:00:00', end: '18:00:00'),
        ];
        final session = CalendarEvent(
          session: Session(
            id: 's1',
            tenantId: 'tid',
            clientId: 'cid',
            type: SessionType.portrait,
            status: SessionStatus.scheduled,
            scheduledAt: DateTime(2026, 3, 18, 11, 0),
            paymentStatus: PaymentStatus.pending,
            amount: 100.0,
            durationMinutes: 30,
            createdAt: _wednesday,
            updatedAt: _wednesday,
          ),
          clientFirstName: 'Alice',
          clientLastName: 'Dupont',
        );

        final slots = computeEffectiveAvailability(rules, [
          session,
        ], _wednesday);

        // [09:00-11:00] and [11:30-18:00]
        expect(slots.length, 2);
        expect(slots[0].start, DateTime(2026, 3, 18, 9, 0));
        expect(slots[0].end, DateTime(2026, 3, 18, 11, 0));
        expect(slots[1].start, DateTime(2026, 3, 18, 11, 30));
        expect(slots[1].end, DateTime(2026, 3, 18, 18, 0));
      });
    });

    group('external events', () {
      test('all-day event blocks full day', () {
        final rules = [
          _recurring(dayOfWeek: 3, start: '09:00:00', end: '18:00:00'),
        ];
        final allDay = ExternalCalendarEvent(
          id: 'e1',
          tenantId: 'tid',
          googleEventId: 'g1',
          title: 'Holiday',
          startAt: DateTime(2026, 3, 18),
          endAt: DateTime(2026, 3, 19),
          isAllDay: true,
          status: 'confirmed',
          createdAt: _wednesday,
          updatedAt: _wednesday,
        );

        final slots = computeEffectiveAvailability(
          rules,
          [],
          _wednesday,
          externalEvents: [allDay],
        );

        expect(slots, isEmpty);
      });

      test('timed external event subtracts its window', () {
        final rules = [
          _recurring(dayOfWeek: 3, start: '09:00:00', end: '18:00:00'),
        ];
        final ext = ExternalCalendarEvent(
          id: 'e2',
          tenantId: 'tid',
          googleEventId: 'g2',
          title: 'Meeting',
          startAt: DateTime(2026, 3, 18, 10, 0),
          endAt: DateTime(2026, 3, 18, 11, 0),
          isAllDay: false,
          status: 'confirmed',
          createdAt: _wednesday,
          updatedAt: _wednesday,
        );

        final slots = computeEffectiveAvailability(
          rules,
          [],
          _wednesday,
          externalEvents: [ext],
        );

        expect(slots.length, 2);
        expect(slots[0].start, DateTime(2026, 3, 18, 9, 0));
        expect(slots[0].end, DateTime(2026, 3, 18, 10, 0));
        expect(slots[1].start, DateTime(2026, 3, 18, 11, 0));
        expect(slots[1].end, DateTime(2026, 3, 18, 18, 0));
      });
    });
  });
}
