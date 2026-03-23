import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/repositories/client_repository.dart';
import '../usecase.dart';
import 'params.dart';

final class DeleteClient extends UseCase<void, DeleteClientParams> {
  const DeleteClient(this._clientRepository);

  final ClientWriter _clientRepository;

  @override
  Future<Result<void, Failure>> call(DeleteClientParams params) =>
      _clientRepository.delete(params.id);
}
