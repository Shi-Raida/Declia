import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../usecase.dart';
import 'params.dart';

final class UpdateClient extends UseCase<Client, UpdateClientParams> {
  const UpdateClient(this._clientRepository);

  final ClientRepository _clientRepository;

  @override
  Future<Result<Client, Failure>> call(UpdateClientParams params) =>
      _clientRepository.update(params.client);
}
