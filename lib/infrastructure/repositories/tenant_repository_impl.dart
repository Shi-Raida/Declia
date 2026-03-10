import '../../core/errors/app_exception.dart';
import '../../domain/entities/tenant.dart';
import '../../domain/repositories/tenant_repository.dart';
import '../datasources/tenant_data_source.dart';

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
    final json = await _dataSource.fetchCurrentUserTenant();
    return Tenant.fromJson(json.cast<String, dynamic>());
  }

  @override
  Future<Tenant> fetchById(String id) async {
    final json = await _dataSource.fetchById(id);
    return Tenant.fromJson(json.cast<String, dynamic>());
  }
}
