import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/client_history.dart';
import 'package:declia/domain/entities/client_summary_stats.dart';
import 'package:declia/domain/repositories/client_history_repository.dart';
import 'package:declia/usecases/client_history/fetch_client_history.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeClientHistoryRepository implements ClientHistoryRepository {
  ClientHistory? historyToReturn;
  Failure? failureToReturn;

  @override
  Future<Result<ClientHistory, Failure>> fetchByClientId(
    String clientId,
  ) async {
    if (failureToReturn != null) return Err(failureToReturn!);
    return Ok(
      historyToReturn ??
          ClientHistory(
            clientId: clientId,
            sessions: const [],
            galleries: const [],
            orders: const [],
            communicationLogs: const [],
          ),
    );
  }

  @override
  Future<Result<Map<String, ClientSummaryStats>, Failure>> fetchSummaryStats(
    List<String> clientIds,
  ) async => const Ok({});
}

void main() {
  group('FetchClientHistory', () {
    test('returns ClientHistory on success', () async {
      final repo = _FakeClientHistoryRepository();
      final useCase = FetchClientHistory(repo);

      final result = await useCase((clientId: 'client-1'));

      expect(result.isOk, isTrue);
      result.fold(
        ok: (h) => expect(h.clientId, 'client-1'),
        err: (_) => fail('expected ok'),
      );
    });

    test('returns empty history with no data', () async {
      final repo = _FakeClientHistoryRepository();
      final useCase = FetchClientHistory(repo);

      final result = await useCase((clientId: 'client-empty'));

      expect(result.isOk, isTrue);
      result.fold(
        ok: (h) {
          expect(h.sessions, isEmpty);
          expect(h.galleries, isEmpty);
          expect(h.orders, isEmpty);
          expect(h.communicationLogs, isEmpty);
        },
        err: (_) => fail('expected ok'),
      );
    });

    test('returns failure on repository error', () async {
      final repo = _FakeClientHistoryRepository()
        ..failureToReturn = const RepositoryFailure('DB error');
      final useCase = FetchClientHistory(repo);

      final result = await useCase((clientId: 'client-1'));

      expect(result.isOk, isFalse);
      result.fold(
        ok: (_) => fail('expected error'),
        err: (f) => expect(f.message, 'DB error'),
      );
    });
  });
}
