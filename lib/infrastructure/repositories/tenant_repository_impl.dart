import '../../core/errors/app_exception.dart';
import '../../domain/entities/tenant.dart';
import '../../domain/repositories/tenant_repository.dart';
import '../../domain/datasources/tenant_data_source.dart';

typedef CurrentUserIdProvider = String? Function();

final class TenantRepositoryImpl implements TenantRepository {
  const TenantRepositoryImpl({
    required TenantDataSource dataSource,
    required CurrentUserIdProvider currentUserId,
  }) : _dataSource = dataSource,
       _currentUserId = currentUserId;

  final TenantDataSource _dataSource;
  final CurrentUserIdProvider _currentUserId;

  @override
  Future<Tenant> fetchCurrentUserTenant() async {
    if (_currentUserId() == null) {
      throw const UnauthorisedTenantAccessException();
    }
    return _dataSource.fetchCurrentUserTenant();
  }

  @override
  Future<Tenant> fetchById(String id) => _dataSource.fetchById(id);
}
