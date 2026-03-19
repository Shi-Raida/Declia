import '../../core/errors/failures.dart';
import '../../core/repositories/repository_guard.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/client_history.dart';
import '../../domain/entities/client_summary_stats.dart';
import '../../domain/repositories/client_history_repository.dart';
import '../datasources/contract/client_history_data_source.dart';

final class ClientHistoryRepositoryImpl implements ClientHistoryRepository {
  const ClientHistoryRepositoryImpl({
    required ClientHistoryDataSource dataSource,
    required RepositoryGuard guard,
  }) : _dataSource = dataSource,
       _guard = guard;

  final ClientHistoryDataSource _dataSource;
  final RepositoryGuard _guard;

  @override
  Future<Result<ClientHistory, Failure>> fetchByClientId(String clientId) =>
      _guard(() async {
        // Launch all fetches in parallel
        final sessionsFuture = _dataSource.fetchSessions(clientId);
        final galleriesFuture = _dataSource.fetchGalleries(clientId);
        final ordersFuture = _dataSource.fetchOrders(clientId);
        final commLogsFuture = _dataSource.fetchCommunicationLogs(clientId);

        return ClientHistory(
          clientId: clientId,
          sessions: await sessionsFuture,
          galleries: await galleriesFuture,
          orders: await ordersFuture,
          communicationLogs: await commLogsFuture,
        );
      }, method: 'fetchByClientId');

  @override
  Future<Result<Map<String, ClientSummaryStats>, Failure>> fetchSummaryStats(
    List<String> clientIds,
  ) async {
    final result = await _guard(
      () => _dataSource.fetchSummaryStats(clientIds),
      method: 'fetchSummaryStats',
    );
    return result.map(
      (rawMap) => rawMap.map(
        (id, row) => MapEntry(
          id,
          ClientSummaryStats(
            clientId: id,
            sessionCount: (row['session_count'] as num?)?.toInt() ?? 0,
            totalSpent: (row['total_spent'] as num?)?.toDouble() ?? 0.0,
            lastShooting: row['last_shooting'] != null
                ? DateTime.parse(row['last_shooting'] as String)
                : null,
          ),
        ),
      ),
    );
  }
}
