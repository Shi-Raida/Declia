import '../../core/errors/failures.dart';
import '../../core/repositories/repository_guard.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/tenant.dart';
import '../../domain/repositories/tenant_repository.dart';
import '../datasources/contract/tenant_data_source.dart';

typedef CurrentUserIdProvider = String? Function();

final class TenantRepositoryImpl implements TenantRepository {
  const TenantRepositoryImpl({
    required TenantDataSource dataSource,
    required CurrentUserIdProvider currentUserId,
    required RepositoryGuard guard,
  }) : _dataSource = dataSource,
       _currentUserId = currentUserId,
       _guard = guard;

  final TenantDataSource _dataSource;
  final CurrentUserIdProvider _currentUserId;
  final RepositoryGuard _guard;

  @override
  Future<Result<Tenant, Failure>> fetchCurrentUserTenant() async {
    if (_currentUserId() == null) {
      return const Err(
        UnauthorisedTenantAccessFailure('Unauthorised access to tenant'),
      );
    }
    return _guard(
      () => _dataSource.fetchCurrentUserTenant(),
      method: 'fetchCurrentUserTenant',
    );
  }

  @override
  Future<Result<Tenant, Failure>> fetchById(String id) =>
      _guard(() => _dataSource.fetchById(id), method: 'fetchById');
}
