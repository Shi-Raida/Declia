import 'package:declia/core/errors/failures.dart';
import 'package:declia/domain/entities/communication_log.dart';
import 'package:declia/domain/entities/gallery.dart';
import 'package:declia/domain/entities/order.dart';
import 'package:declia/domain/entities/session.dart';
import 'package:declia/infrastructure/datasources/contract/client_history_data_source.dart';
import 'package:declia/infrastructure/repositories/client_history_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../helpers/mocks.dart';

final class _FakeClientHistoryDataSource implements ClientHistoryDataSource {
  List<Session> sessions = const [];
  List<Gallery> galleries = const [];
  List<Order> orders = const [];
  List<CommunicationLog> commLogs = const [];
  Map<String, Map<String, dynamic>> summaryStats = const {};
  Exception? errorToThrow;

  @override
  Future<List<Session>> fetchSessions(String clientId) async {
    if (errorToThrow != null) throw errorToThrow!;
    return sessions;
  }

  @override
  Future<List<Gallery>> fetchGalleries(String clientId) async {
    if (errorToThrow != null) throw errorToThrow!;
    return galleries;
  }

  @override
  Future<List<Order>> fetchOrders(String clientId) async {
    if (errorToThrow != null) throw errorToThrow!;
    return orders;
  }

  @override
  Future<List<CommunicationLog>> fetchCommunicationLogs(String clientId) async {
    if (errorToThrow != null) throw errorToThrow!;
    return commLogs;
  }

  @override
  Future<Map<String, Map<String, dynamic>>> fetchSummaryStats(
    List<String> clientIds,
  ) async {
    if (errorToThrow != null) throw errorToThrow!;
    return summaryStats;
  }
}

void main() {
  group('ClientHistoryRepositoryImpl', () {
    group('fetchByClientId', () {
      test('assembles aggregate from all data sources', () async {
        final ds = _FakeClientHistoryDataSource();
        final repo = ClientHistoryRepositoryImpl(
          dataSource: ds,
          guard: MockRepositoryGuard(),
        );

        final result = await repo.fetchByClientId('client-1');

        expect(result.isOk, isTrue);
        result.fold(
          ok: (h) {
            expect(h.clientId, 'client-1');
            expect(h.sessions, isEmpty);
            expect(h.galleries, isEmpty);
            expect(h.orders, isEmpty);
            expect(h.communicationLogs, isEmpty);
          },
          err: (_) => fail('expected ok'),
        );
      });

      test('returns failure when data source throws', () async {
        final ds = _FakeClientHistoryDataSource()
          ..errorToThrow = Exception('network error');
        final guard = MockRepositoryGuard()..isOnline = false;
        final repo = ClientHistoryRepositoryImpl(dataSource: ds, guard: guard);

        final result = await repo.fetchByClientId('client-1');

        expect(result.isOk, isFalse);
      });
    });

    group('fetchSummaryStats', () {
      test('maps raw rows to ClientSummaryStats', () async {
        final ds = _FakeClientHistoryDataSource()
          ..summaryStats = {
            'c1': {
              'client_id': 'c1',
              'session_count': 5,
              'total_spent': 750.0,
              'last_shooting': null,
            },
          };
        final repo = ClientHistoryRepositoryImpl(
          dataSource: ds,
          guard: MockRepositoryGuard(),
        );

        final result = await repo.fetchSummaryStats(['c1']);

        expect(result.isOk, isTrue);
        result.fold(
          ok: (m) {
            expect(m['c1']?.sessionCount, 5);
            expect(m['c1']?.totalSpent, 750.0);
            expect(m['c1']?.lastShooting, isNull);
          },
          err: (_) => fail('expected ok'),
        );
      });

      test('returns empty map when no client ids', () async {
        final ds = _FakeClientHistoryDataSource();
        final repo = ClientHistoryRepositoryImpl(
          dataSource: ds,
          guard: MockRepositoryGuard(),
        );

        final result = await repo.fetchSummaryStats([]);

        expect(result.isOk, isTrue);
        result.fold(
          ok: (m) => expect(m, isEmpty),
          err: (_) => fail('expected ok'),
        );
      });

      test('parses last_shooting date when present', () async {
        final ds = _FakeClientHistoryDataSource()
          ..summaryStats = {
            'c1': {
              'client_id': 'c1',
              'session_count': 2,
              'total_spent': 200.0,
              'last_shooting': '2026-01-15T10:00:00.000Z',
            },
          };
        final repo = ClientHistoryRepositoryImpl(
          dataSource: ds,
          guard: MockRepositoryGuard(),
        );

        final result = await repo.fetchSummaryStats(['c1']);

        result.fold(
          ok: (m) {
            expect(m['c1']?.lastShooting, isNotNull);
            expect(m['c1']?.lastShooting?.year, 2026);
          },
          err: (_) => fail('expected ok'),
        );
      });

      test('returns failure on guard error', () async {
        final ds = _FakeClientHistoryDataSource();
        final guard = MockRepositoryGuard()
          ..failureOverride = const RepositoryFailure('DB down');
        final repo = ClientHistoryRepositoryImpl(dataSource: ds, guard: guard);

        final result = await repo.fetchSummaryStats(['c1']);

        expect(result.isOk, isFalse);
        result.fold(
          ok: (_) => fail('expected error'),
          err: (f) => expect(f.message, 'DB down'),
        );
      });
    });
  });
}
