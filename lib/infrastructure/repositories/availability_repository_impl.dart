import '../../core/errors/failures.dart';
import '../../core/repositories/repository_guard.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/availability_rule.dart';
import '../../domain/repositories/availability_repository.dart';
import '../datasources/contract/availability_data_source.dart';

final class AvailabilityRepositoryImpl implements AvailabilityRepository {
  const AvailabilityRepositoryImpl({
    required AvailabilityDataSource dataSource,
    required RepositoryGuard guard,
  }) : _dataSource = dataSource,
       _guard = guard;

  final AvailabilityDataSource _dataSource;
  final RepositoryGuard _guard;

  @override
  Future<Result<List<AvailabilityRule>, Failure>> fetchAll() =>
      _guard(() => _dataSource.fetchAll(), method: 'fetchAll');

  @override
  Future<Result<AvailabilityRule, Failure>> create(AvailabilityRule rule) =>
      _guard(() => _dataSource.create(rule), method: 'create');

  @override
  Future<Result<AvailabilityRule, Failure>> update(AvailabilityRule rule) =>
      _guard(() => _dataSource.update(rule), method: 'update');

  @override
  Future<Result<void, Failure>> delete(String id) =>
      _guard(() => _dataSource.delete(id), method: 'delete');
}
