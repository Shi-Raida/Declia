import '../../core/errors/failures.dart';
import '../../core/utils/clock.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/availability_rule.dart';
import '../../domain/repositories/availability_repository.dart';
import '../usecase.dart';
import 'params.dart';

final class CreateAvailabilityRule
    extends UseCase<AvailabilityRule, CreateAvailabilityRuleParams> {
  const CreateAvailabilityRule(this._repository, this._clock);

  final AvailabilityRepository _repository;
  final Clock _clock;

  @override
  Future<Result<AvailabilityRule, Failure>> call(
    CreateAvailabilityRuleParams params,
  ) {
    final now = _clock.now().toUtc();
    final rule = params.rule.copyWith(createdAt: now, updatedAt: now);
    return _repository.create(rule);
  }
}
