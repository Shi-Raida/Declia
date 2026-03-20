import 'package:declia/domain/entities/external_calendar_event.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 3, 21, 10, 0);
  final later = DateTime(2026, 3, 21, 11, 0);

  ExternalCalendarEvent makeEvent() => ExternalCalendarEvent(
    id: 'e1',
    tenantId: 'tid',
    googleEventId: 'google-123',
    title: 'Team meeting',
    location: 'Paris',
    startAt: now,
    endAt: later,
    isAllDay: false,
    status: 'confirmed',
    createdAt: now,
    updatedAt: now,
  );

  group('ExternalCalendarEvent JSON round-trip', () {
    test('serializes and deserializes correctly', () {
      final event = makeEvent();

      final json = event.toJson();
      final restored = ExternalCalendarEvent.fromJson(json);

      expect(restored.id, event.id);
      expect(restored.tenantId, event.tenantId);
      expect(restored.googleEventId, 'google-123');
      expect(restored.title, 'Team meeting');
      expect(restored.location, 'Paris');
      expect(restored.isAllDay, isFalse);
      expect(restored.status, 'confirmed');
      expect(restored.source, 'google');
    });

    test('default source is google', () {
      final event = makeEvent();
      expect(event.source, 'google');
    });

    test('all-day event serializes correctly', () {
      final event = ExternalCalendarEvent(
        id: 'e2',
        tenantId: 'tid',
        googleEventId: 'google-456',
        title: 'Public holiday',
        startAt: DateTime(2026, 5, 1),
        endAt: DateTime(2026, 5, 1, 23, 59, 59),
        isAllDay: true,
        status: 'confirmed',
        createdAt: now,
        updatedAt: now,
      );

      final json = event.toJson();
      final restored = ExternalCalendarEvent.fromJson(json);

      expect(restored.isAllDay, isTrue);
      expect(restored.location, isNull);
    });

    test('copyWith updates fields correctly', () {
      final event = makeEvent();
      final updated = event.copyWith(
        title: 'Updated meeting',
        status: 'cancelled',
      );

      expect(updated.title, 'Updated meeting');
      expect(updated.status, 'cancelled');
      expect(updated.id, event.id);
    });
  });
}
