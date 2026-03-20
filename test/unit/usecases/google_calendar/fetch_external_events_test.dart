import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/external_calendar_event.dart';
import 'package:declia/domain/entities/google_calendar_connection.dart';
import 'package:declia/domain/repositories/google_calendar_repository.dart';
import 'package:declia/usecases/google_calendar/fetch_external_events.dart';
import 'package:declia/usecases/google_calendar/params.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 3, 21, 10, 0);

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

final class _FakeGoogleCalendarRepository implements GoogleCalendarRepository {
  List<ExternalCalendarEvent> eventsToReturn = [];
  Failure? failureToReturn;
  DateTime? lastStart;
  DateTime? lastEnd;

  @override
  Future<Result<List<ExternalCalendarEvent>, Failure>> fetchExternalEvents({
    required DateTime start,
    required DateTime end,
  }) async {
    lastStart = start;
    lastEnd = end;
    if (failureToReturn != null) return Err(failureToReturn!);
    return Ok(eventsToReturn);
  }

  @override
  Future<Result<String, Failure>> getAuthUrl() async => const Ok('');
  @override
  Future<Result<void, Failure>> exchangeCode(String code) async => const Ok(null);
  @override
  Future<Result<void, Failure>> disconnect() async => const Ok(null);
  @override
  Future<Result<GoogleCalendarConnection?, Failure>> getConnectionStatus() async => const Ok(null);
  @override
  Future<Result<void, Failure>> toggleSync({required String id, required bool enabled}) async => const Ok(null);
  @override
  Future<Result<void, Failure>> triggerSync() async => const Ok(null);
}

void main() {
  group('FetchExternalEvents', () {
    test('returns events from repository', () async {
      final repo = _FakeGoogleCalendarRepository()..eventsToReturn = [_event()];
      final useCase = FetchExternalEvents(repo);

      final start = DateTime(2026, 3, 1);
      final end = DateTime(2026, 3, 31);
      final result = await useCase((start: start, end: end));

      expect(result.isOk, isTrue);
      result.fold(
        ok: (events) {
          expect(events.length, 1);
          expect(events.first.googleEventId, 'google-123');
        },
        err: (_) => fail('expected ok'),
      );
    });

    test('passes date range to repository', () async {
      final repo = _FakeGoogleCalendarRepository();
      final useCase = FetchExternalEvents(repo);

      final start = DateTime(2026, 3, 1);
      final end = DateTime(2026, 3, 31);
      await useCase((start: start, end: end));

      expect(repo.lastStart, start);
      expect(repo.lastEnd, end);
    });

    test('returns empty list when no events', () async {
      final repo = _FakeGoogleCalendarRepository();
      final useCase = FetchExternalEvents(repo);

      final result = await useCase(
        (start: DateTime(2026, 3, 1), end: DateTime(2026, 3, 31)),
      );

      expect(result.isOk, isTrue);
      result.fold(
        ok: (events) => expect(events, isEmpty),
        err: (_) => fail('expected ok'),
      );
    });

    test('propagates failure', () async {
      final repo = _FakeGoogleCalendarRepository()
        ..failureToReturn = const RepositoryFailure('fetch error');
      final useCase = FetchExternalEvents(repo);

      final result = await useCase(
        (start: DateTime(2026, 3, 1), end: DateTime(2026, 3, 31)),
      );

      expect(result.isOk, isFalse);
    });
  });
}
