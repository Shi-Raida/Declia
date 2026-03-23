import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../usecase.dart';

final class FetchClients extends UseCase<List<Client>, NoParams> {
  const FetchClients(this._clientRepository);

  final ClientReader _clientRepository;

  @override
  Future<Result<List<Client>, Failure>> call(NoParams params) =>
      _clientRepository.fetchAll();
}
