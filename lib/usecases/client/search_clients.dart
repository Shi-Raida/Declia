import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../usecase.dart';
import 'params.dart';

final class SearchClients extends UseCase<List<Client>, SearchClientsParams> {
  const SearchClients(this._clientRepository);

  final ClientReader _clientRepository;

  @override
  Future<Result<List<Client>, Failure>> call(SearchClientsParams params) =>
      _clientRepository.search(params.query);
}
