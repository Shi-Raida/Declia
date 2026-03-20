import 'package:declia/core/errors/app_exception.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/infrastructure/datasources/contract/calendar_data_source.dart';
import 'package:declia/infrastructure/repositories/calendar_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mocks.dart';

final class _FakeCalendarDataSource implements CalendarDataSource {
  List<Map<String, dynamic>> rowsToReturn = [];
  Exception? errorToThrow;

  @override
  Future<List<Map<String, dynamic>>> fetchSessionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    if (errorToThrow != null) throw errorToThrow!;
    return rowsToReturn;
  }
}

Map<String, dynamic> _sessionRow({
  String id = 's1',
  String clientId = 'cid',
  String? firstName = 'Alice',
  String? lastName = 'Dupont',
}) => {
  'id': id,
  'tenant_id': 'tid',
  'client_id': clientId,
  'type': 'portrait',
  'status': 'scheduled',
  'scheduled_at': '2026-03-19T10:00:00.000Z',
  'location': null,
  'payment_status': 'pending',
  'amount': 150.0,
  'notes': null,
  'created_at': '2026-03-01T00:00:00.000Z',
  'updated_at': '2026-03-01T00:00:00.000Z',
  'clients': {'first_name': firstName, 'last_name': lastName},
};

void main() {
  group('CalendarRepositoryImpl', () {
    group('fetchByDateRange', () {
      test('maps rows to CalendarEvent list', () async {
        final ds = _FakeCalendarDataSource()..rowsToReturn = [_sessionRow()];
        final repo = CalendarRepositoryImpl(
          dataSource: ds,
          guard: MockRepositoryGuard(),
        );

        final result = await repo.fetchByDateRange(
          DateTime(2026, 3, 1),
          DateTime(2026, 3, 31),
        );

        expect(result.isOk, isTrue);
        result.fold(
          ok: (events) {
            expect(events.length, 1);
            expect(events.first.clientFirstName, 'Alice');
            expect(events.first.clientLastName, 'Dupont');
            expect(events.first.session.id, 's1');
          },
          err: (_) => fail('expected ok'),
        );
      });

      test('returns empty list when no sessions in range', () async {
        final ds = _FakeCalendarDataSource();
        final repo = CalendarRepositoryImpl(
          dataSource: ds,
          guard: MockRepositoryGuard(),
        );

        final result = await repo.fetchByDateRange(
          DateTime(2026, 3, 1),
          DateTime(2026, 3, 31),
        );

        expect(result.isOk, isTrue);
        result.fold(
          ok: (events) => expect(events, isEmpty),
          err: (_) => fail('expected ok'),
        );
      });

      test('returns failure when guard is offline', () async {
        final ds = _FakeCalendarDataSource()
          ..errorToThrow = const RepositoryException('network');
        final guard = MockRepositoryGuard()..isOnline = false;
        final repo = CalendarRepositoryImpl(dataSource: ds, guard: guard);

        final result = await repo.fetchByDateRange(
          DateTime(2026, 3, 1),
          DateTime(2026, 3, 31),
        );

        expect(result.isOk, isFalse);
      });

      test('returns failure on guard failure override', () async {
        final ds = _FakeCalendarDataSource();
        final guard = MockRepositoryGuard()
          ..failureOverride = const RepositoryFailure('DB error');
        final repo = CalendarRepositoryImpl(dataSource: ds, guard: guard);

        final result = await repo.fetchByDateRange(
          DateTime(2026, 3, 1),
          DateTime(2026, 3, 31),
        );

        expect(result.isOk, isFalse);
        result.fold(
          ok: (_) => fail('expected error'),
          err: (f) => expect(f.message, 'DB error'),
        );
      });
    });
  });
}
