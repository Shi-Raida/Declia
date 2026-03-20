import 'package:declia/core/errors/app_exception.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/domain/entities/external_calendar_event.dart';
import 'package:declia/domain/entities/google_calendar_connection.dart';
import 'package:declia/infrastructure/datasources/contract/google_calendar_data_source.dart';
import 'package:declia/infrastructure/repositories/google_calendar_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mocks.dart';

final _now = DateTime(2026, 3, 21, 10, 0);

GoogleCalendarConnection _connection() => GoogleCalendarConnection(
  id: 'c1',
  tenantId: 'tid',
  calendarId: 'primary',
  syncEnabled: true,
  createdAt: _now,
  updatedAt: _now,
);

ExternalCalendarEvent _event() => ExternalCalendarEvent(
  id: 'e1',
  tenantId: 'tid',
  googleEventId: 'google-123',
  title: 'Meeting',
  startAt: _now,
  endAt: _now.add(const Duration(hours: 1)),
  isAllDay: false,
  status: 'confirmed',
  createdAt: _now,
  updatedAt: _now,
);

final class _FakeGoogleCalendarDataSource implements GoogleCalendarDataSource {
  String urlToReturn = 'https://accounts.google.com/auth';
  GoogleCalendarConnection? connectionToReturn;
  List<ExternalCalendarEvent> eventsToReturn = [];
  Exception? errorToThrow;

  @override
  Future<String> getAuthUrl() async {
    if (errorToThrow != null) throw errorToThrow!;
    return urlToReturn;
  }

  @override
  Future<void> exchangeCode(String code) async {
    if (errorToThrow != null) throw errorToThrow!;
  }

  @override
  Future<void> disconnect() async {
    if (errorToThrow != null) throw errorToThrow!;
  }

  @override
  Future<GoogleCalendarConnection?> getConnectionStatus() async {
    if (errorToThrow != null) throw errorToThrow!;
    return connectionToReturn;
  }

  @override
  Future<void> toggleSync({required String id, required bool enabled}) async {
    if (errorToThrow != null) throw errorToThrow!;
  }

  @override
  Future<void> triggerSync() async {
    if (errorToThrow != null) throw errorToThrow!;
  }

  @override
  Future<List<ExternalCalendarEvent>> fetchExternalEvents({
    required DateTime start,
    required DateTime end,
  }) async {
    if (errorToThrow != null) throw errorToThrow!;
    return eventsToReturn;
  }
}

void main() {
  group('GoogleCalendarRepositoryImpl', () {
    group('getAuthUrl', () {
      test('returns URL from data source', () async {
        final ds = _FakeGoogleCalendarDataSource();
        final repo = GoogleCalendarRepositoryImpl(
          dataSource: ds,
          guard: MockRepositoryGuard(),
        );

        final result = await repo.getAuthUrl();

        expect(result.isOk, isTrue);
        result.fold(
          ok: (url) => expect(url, contains('accounts.google.com')),
          err: (_) => fail('expected ok'),
        );
      });

      test('returns failure when guard is offline', () async {
        final ds = _FakeGoogleCalendarDataSource();
        final guard = MockRepositoryGuard()..isOnline = false;
        final repo = GoogleCalendarRepositoryImpl(dataSource: ds, guard: guard);

        final result = await repo.getAuthUrl();

        expect(result.isOk, isFalse);
      });
    });

    group('getConnectionStatus', () {
      test('returns connection from data source', () async {
        final ds = _FakeGoogleCalendarDataSource()
          ..connectionToReturn = _connection();
        final repo = GoogleCalendarRepositoryImpl(
          dataSource: ds,
          guard: MockRepositoryGuard(),
        );

        final result = await repo.getConnectionStatus();

        expect(result.isOk, isTrue);
        result.fold(
          ok: (conn) => expect(conn?.calendarId, 'primary'),
          err: (_) => fail('expected ok'),
        );
      });

      test('returns null when not connected', () async {
        final ds = _FakeGoogleCalendarDataSource();
        final repo = GoogleCalendarRepositoryImpl(
          dataSource: ds,
          guard: MockRepositoryGuard(),
        );

        final result = await repo.getConnectionStatus();

        expect(result.isOk, isTrue);
        result.fold(
          ok: (conn) => expect(conn, isNull),
          err: (_) => fail('expected ok'),
        );
      });
    });

    group('fetchExternalEvents', () {
      test('returns events from data source', () async {
        final ds = _FakeGoogleCalendarDataSource()..eventsToReturn = [_event()];
        final repo = GoogleCalendarRepositoryImpl(
          dataSource: ds,
          guard: MockRepositoryGuard(),
        );

        final result = await repo.fetchExternalEvents(
          start: DateTime(2026, 3, 1),
          end: DateTime(2026, 3, 31),
        );

        expect(result.isOk, isTrue);
        result.fold(
          ok: (events) => expect(events.length, 1),
          err: (_) => fail('expected ok'),
        );
      });

      test('returns failure on data source error', () async {
        final ds = _FakeGoogleCalendarDataSource()
          ..errorToThrow = const RepositoryException('fetch error');
        final repo = GoogleCalendarRepositoryImpl(
          dataSource: ds,
          guard: MockRepositoryGuard(),
        );

        final result = await repo.fetchExternalEvents(
          start: DateTime(2026, 3, 1),
          end: DateTime(2026, 3, 31),
        );

        expect(result.isOk, isFalse);
        result.fold(
          ok: (_) => fail('expected error'),
          err: (f) => expect(f.message, 'fetch error'),
        );
      });
    });

    group('disconnect', () {
      test('delegates to data source', () async {
        final ds = _FakeGoogleCalendarDataSource();
        final repo = GoogleCalendarRepositoryImpl(
          dataSource: ds,
          guard: MockRepositoryGuard(),
        );

        final result = await repo.disconnect();

        expect(result.isOk, isTrue);
      });

      test('returns failure when guard override set', () async {
        final ds = _FakeGoogleCalendarDataSource();
        final guard = MockRepositoryGuard()
          ..failureOverride = const RepositoryFailure('DB error');
        final repo = GoogleCalendarRepositoryImpl(dataSource: ds, guard: guard);

        final result = await repo.disconnect();

        expect(result.isOk, isFalse);
        result.fold(
          ok: (_) => fail('expected error'),
          err: (f) => expect(f.message, 'DB error'),
        );
      });
    });
  });
}
