import '../../core/errors/failures.dart';
import '../../core/utils/paged_result.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../usecase.dart';
import 'params.dart';

final class FetchClientList
    extends UseCase<PagedResult<Client>, FetchClientsParams> {
  const FetchClientList(this._clientRepository);

  final ClientRepository _clientRepository;

  @override
  Future<Result<PagedResult<Client>, Failure>> call(
    FetchClientsParams params,
  ) => _clientRepository.fetchList(params.query);
}
