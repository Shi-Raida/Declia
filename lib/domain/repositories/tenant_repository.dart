import '../entities/tenant.dart';

abstract interface class TenantRepository {
  Future<Tenant> fetchCurrentUserTenant();
  Future<Tenant> fetchById(String id);
}
