import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/repositories/client_repository.dart';
import '../usecase.dart';

final class FetchDistinctTags extends UseCase<List<String>, NoParams> {
  const FetchDistinctTags(this._clientRepository);

  final ClientRepository _clientRepository;

  @override
  Future<Result<List<String>, Failure>> call(NoParams params) =>
      _clientRepository.fetchDistinctTags();
}
