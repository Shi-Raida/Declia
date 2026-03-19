import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/repositories/availability_repository.dart';
import '../usecase.dart';
import 'params.dart';

final class DeleteAvailabilityRule
    extends UseCase<void, DeleteAvailabilityRuleParams> {
  const DeleteAvailabilityRule(this._repository);

  final AvailabilityRepository _repository;

  @override
  Future<Result<void, Failure>> call(DeleteAvailabilityRuleParams params) =>
      _repository.delete(params.id);
}
