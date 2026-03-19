import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/client_history.dart';
import 'package:declia/domain/entities/client_summary_stats.dart';
import 'package:declia/domain/repositories/client_history_repository.dart';
import 'package:declia/usecases/client_history/fetch_summary_stats.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeClientHistoryRepository implements ClientHistoryRepository {
  Map<String, ClientSummaryStats>? statsToReturn;
  Failure? failureToReturn;

  @override
  Future<Result<ClientHistory, Failure>> fetchByClientId(
    String clientId,
  ) async => Ok(
    ClientHistory(
      clientId: clientId,
      sessions: const [],
      galleries: const [],
      orders: const [],
      communicationLogs: const [],
    ),
  );

  @override
  Future<Result<Map<String, ClientSummaryStats>, Failure>> fetchSummaryStats(
    List<String> clientIds,
  ) async {
    if (failureToReturn != null) return Err(failureToReturn!);
    return Ok(statsToReturn ?? {});
  }
}

void main() {
  group('FetchSummaryStats', () {
    test('returns stats map on success', () async {
      final stats = {
        'c1': const ClientSummaryStats(
          clientId: 'c1',
          sessionCount: 3,
          totalSpent: 450.0,
        ),
      };
      final repo = _FakeClientHistoryRepository()..statsToReturn = stats;
      final useCase = FetchSummaryStats(repo);

      final result = await useCase((clientIds: ['c1']));

      expect(result.isOk, isTrue);
      result.fold(
        ok: (m) {
          expect(m['c1']?.sessionCount, 3);
          expect(m['c1']?.totalSpent, 450.0);
        },
        err: (_) => fail('expected ok'),
      );
    });

    test('returns empty map when no clients', () async {
      final repo = _FakeClientHistoryRepository();
      final useCase = FetchSummaryStats(repo);

      final result = await useCase((clientIds: []));

      expect(result.isOk, isTrue);
      result.fold(
        ok: (m) => expect(m, isEmpty),
        err: (_) => fail('expected ok'),
      );
    });

    test('returns failure on repository error', () async {
      final repo = _FakeClientHistoryRepository()
        ..failureToReturn = const RepositoryFailure('stats error');
      final useCase = FetchSummaryStats(repo);

      final result = await useCase((clientIds: ['c1']));

      expect(result.isOk, isFalse);
      result.fold(
        ok: (_) => fail('expected error'),
        err: (f) => expect(f.message, 'stats error'),
      );
    });
  });
}
