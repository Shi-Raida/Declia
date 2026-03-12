import '../entities/tenant.dart';

abstract interface class TenantDataSource {
  Future<Tenant> fetchCurrentUserTenant();
  Future<Tenant> fetchById(String id);
}
