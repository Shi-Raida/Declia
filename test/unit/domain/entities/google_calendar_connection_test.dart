import 'package:declia/domain/entities/google_calendar_connection.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime(2026, 3, 21);

  GoogleCalendarConnection makeConnection() => GoogleCalendarConnection(
    id: 'c1',
    tenantId: 'tid',
    calendarId: 'primary',
    syncEnabled: true,
    createdAt: now,
    updatedAt: now,
  );

  group('GoogleCalendarConnection JSON round-trip', () {
    test('serializes and deserializes correctly', () {
      final conn = makeConnection();

      final json = conn.toJson();
      final restored = GoogleCalendarConnection.fromJson(json);

      expect(restored.id, conn.id);
      expect(restored.tenantId, conn.tenantId);
      expect(restored.calendarId, 'primary');
      expect(restored.syncEnabled, isTrue);
      expect(restored.lastSyncAt, isNull);
    });

    test('with lastSyncAt serializes correctly', () {
      final lastSync = DateTime(2026, 3, 21, 9, 0);
      final conn = makeConnection().copyWith(lastSyncAt: lastSync);

      final json = conn.toJson();
      final restored = GoogleCalendarConnection.fromJson(json);

      expect(restored.lastSyncAt, isNotNull);
    });

    test('copyWith updates syncEnabled', () {
      final conn = makeConnection();
      final updated = conn.copyWith(syncEnabled: false);

      expect(updated.syncEnabled, isFalse);
      expect(updated.id, conn.id);
    });
  });
}
