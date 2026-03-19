import '../../core/errors/failures.dart';
import '../../core/utils/clock.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/availability_rule.dart';
import '../../domain/repositories/availability_repository.dart';
import '../usecase.dart';
import 'params.dart';

final class UpdateAvailabilityRule
    extends UseCase<AvailabilityRule, UpdateAvailabilityRuleParams> {
  const UpdateAvailabilityRule(this._repository, this._clock);

  final AvailabilityRepository _repository;
  final Clock _clock;

  @override
  Future<Result<AvailabilityRule, Failure>> call(
    UpdateAvailabilityRuleParams params,
  ) {
    final rule = params.rule.copyWith(updatedAt: _clock.now().toUtc());
    return _repository.update(rule);
  }
}
