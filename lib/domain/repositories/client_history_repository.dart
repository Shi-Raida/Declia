import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../entities/client_history.dart';
import '../entities/client_summary_stats.dart';

abstract interface class ClientHistoryRepository {
  Future<Result<ClientHistory, Failure>> fetchByClientId(String clientId);
  Future<Result<Map<String, ClientSummaryStats>, Failure>> fetchSummaryStats(
    List<String> clientIds,
  );
}
