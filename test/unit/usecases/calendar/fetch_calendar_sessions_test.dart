import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/enums/payment_status.dart';
import 'package:declia/core/enums/session_status.dart';
import 'package:declia/core/enums/session_type.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/calendar_event.dart';
import 'package:declia/domain/entities/session.dart';
import 'package:declia/domain/repositories/calendar_repository.dart';
import 'package:declia/usecases/calendar/fetch_calendar_sessions.dart';
import 'package:flutter_test/flutter_test.dart';

final _now = DateTime(2026, 3, 19);

CalendarEvent _event() => CalendarEvent(
  session: Session(
    id: 's1',
    tenantId: 'tid',
    clientId: 'cid',
    type: SessionType.portrait,
    status: SessionStatus.scheduled,
    scheduledAt: _now,
    paymentStatus: PaymentStatus.pending,
    amount: 150.0,
    createdAt: _now,
    updatedAt: _now,
  ),
  clientFirstName: 'Alice',
  clientLastName: 'Dupont',
);

final class _FakeCalendarRepository implements CalendarRepository {
  List<CalendarEvent> eventsToReturn = [];
  Failure? failureToReturn;

  @override
  Future<Result<List<CalendarEvent>, Failure>> fetchByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    if (failureToReturn != null) return Err(failureToReturn!);
    return Ok(eventsToReturn);
  }
}

void main() {
  group('FetchCalendarSessions', () {
    test('delegates to repository with date range params', () async {
      final repo = _FakeCalendarRepository()..eventsToReturn = [_event()];
      final useCase = FetchCalendarSessions(repo);

      final start = DateTime(2026, 3, 1);
      final end = DateTime(2026, 3, 31);
      final result = await useCase((start: start, end: end));

      expect(result.isOk, isTrue);
      result.fold(
        ok: (list) => expect(list.length, 1),
        err: (_) => fail('expected ok'),
      );
    });

    test('returns empty list when repository returns empty', () async {
      final repo = _FakeCalendarRepository();
      final useCase = FetchCalendarSessions(repo);

      final result = await useCase(
        (start: DateTime(2026, 3, 1), end: DateTime(2026, 3, 31)),
      );

      expect(result.isOk, isTrue);
      result.fold(
        ok: (list) => expect(list, isEmpty),
        err: (_) => fail('expected ok'),
      );
    });

    test('propagates failure from repository', () async {
      final repo = _FakeCalendarRepository()
        ..failureToReturn = const RepositoryFailure('fetch error');
      final useCase = FetchCalendarSessions(repo);

      final result = await useCase(
        (start: DateTime(2026, 3, 1), end: DateTime(2026, 3, 31)),
      );

      expect(result.isOk, isFalse);
      result.fold(
        ok: (_) => fail('expected error'),
        err: (f) => expect(f.message, 'fetch error'),
      );
    });
  });
}
