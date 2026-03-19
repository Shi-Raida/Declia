import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../entities/availability_rule.dart';

abstract interface class AvailabilityRepository {
  Future<Result<List<AvailabilityRule>, Failure>> fetchAll();
  Future<Result<AvailabilityRule, Failure>> create(AvailabilityRule rule);
  Future<Result<AvailabilityRule, Failure>> update(AvailabilityRule rule);
  Future<Result<void, Failure>> delete(String id);
}
