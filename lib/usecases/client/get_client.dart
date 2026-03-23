import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/client.dart';
import '../../domain/repositories/client_repository.dart';
import '../usecase.dart';
import 'params.dart';

final class GetClient extends UseCase<Client, GetClientParams> {
  const GetClient(this._clientRepository);

  final ClientReader _clientRepository;

  @override
  Future<Result<Client, Failure>> call(GetClientParams params) =>
      _clientRepository.fetchById(params.id);
}
