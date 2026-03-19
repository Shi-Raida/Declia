import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/availability_rule.dart';
import '../../domain/repositories/availability_repository.dart';
import '../usecase.dart';

final class FetchAvailabilityRules
    extends UseCase<List<AvailabilityRule>, NoParams> {
  const FetchAvailabilityRules(this._repository);

  final AvailabilityRepository _repository;

  @override
  Future<Result<List<AvailabilityRule>, Failure>> call(NoParams params) =>
      _repository.fetchAll();
}
