import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/client_history.dart';
import '../../domain/repositories/client_history_repository.dart';
import '../usecase.dart';
import 'params.dart';

final class FetchClientHistory
    extends UseCase<ClientHistory, FetchClientHistoryParams> {
  const FetchClientHistory(this._repository);

  final ClientHistoryRepository _repository;

  @override
  Future<Result<ClientHistory, Failure>> call(
    FetchClientHistoryParams params,
  ) => _repository.fetchByClientId(params.clientId);
}
