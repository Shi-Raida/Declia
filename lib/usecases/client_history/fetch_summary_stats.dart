import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/client_summary_stats.dart';
import '../../domain/repositories/client_history_repository.dart';
import '../usecase.dart';
import 'params.dart';

final class FetchSummaryStats
    extends UseCase<Map<String, ClientSummaryStats>, FetchSummaryStatsParams> {
  const FetchSummaryStats(this._repository);

  final ClientHistoryRepository _repository;

  @override
  Future<Result<Map<String, ClientSummaryStats>, Failure>> call(
    FetchSummaryStatsParams params,
  ) => _repository.fetchSummaryStats(params.clientIds);
}
