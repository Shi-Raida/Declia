import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/external_calendar_event.dart';
import 'package:declia/domain/entities/google_calendar_connection.dart';
import 'package:declia/domain/repositories/google_calendar_repository.dart';
import 'package:declia/usecases/google_calendar/get_google_connection_status.dart';
import 'package:declia/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 3, 21);

GoogleCalendarConnection _connection() => GoogleCalendarConnection(
  id: 'c1',
  tenantId: 'tid',
  calendarId: 'primary',
  syncEnabled: true,
  createdAt: _now,
  updatedAt: _now,
);

final class _FakeGoogleCalendarRepository implements GoogleCalendarRepository {
  GoogleCalendarConnection? connectionToReturn;
  Failure? failureToReturn;

  @override
  Future<Result<GoogleCalendarConnection?, Failure>>
  getConnectionStatus() async {
    if (failureToReturn != null) return Err(failureToReturn!);
    return Ok(connectionToReturn);
  }

  @override
  Future<Result<String, Failure>> getAuthUrl() async => const Ok('');
  @override
  Future<Result<void, Failure>> exchangeCode(String code) async =>
      const Ok(null);
  @override
  Future<Result<void, Failure>> disconnect() async => const Ok(null);
  @override
  Future<Result<void, Failure>> toggleSync({
    required String id,
    required bool enabled,
  }) async => const Ok(null);
  @override
  Future<Result<void, Failure>> triggerSync() async => const Ok(null);
  @override
  Future<Result<List<ExternalCalendarEvent>, Failure>> fetchExternalEvents({
    required DateTime start,
    required DateTime end,
  }) async => const Ok([]);
}

void main() {
  group('GetGoogleConnectionStatus', () {
    test('returns connection when connected', () async {
      final repo = _FakeGoogleCalendarRepository()
        ..connectionToReturn = _connection();
      final useCase = GetGoogleConnectionStatus(repo);

      final result = await useCase(const NoParams());

      expect(result.isOk, isTrue);
      result.fold(
        ok: (conn) {
          expect(conn, isNotNull);
          expect(conn!.calendarId, 'primary');
          expect(conn.syncEnabled, isTrue);
        },
        err: (_) => fail('expected ok'),
      );
    });

    test('returns null when not connected', () async {
      final repo = _FakeGoogleCalendarRepository();
      final useCase = GetGoogleConnectionStatus(repo);

      final result = await useCase(const NoParams());

      expect(result.isOk, isTrue);
      result.fold(
        ok: (conn) => expect(conn, isNull),
        err: (_) => fail('expected ok'),
      );
    });

    test('propagates failure', () async {
      final repo = _FakeGoogleCalendarRepository()
        ..failureToReturn = const RepositoryFailure('fetch error');
      final useCase = GetGoogleConnectionStatus(repo);

      final result = await useCase(const NoParams());

      expect(result.isOk, isFalse);
    });
  });
}
