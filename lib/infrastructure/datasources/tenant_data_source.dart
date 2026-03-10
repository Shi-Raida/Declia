abstract interface class TenantDataSource {
  Future<Map<String, Object?>> fetchCurrentUserTenant();
  Future<Map<String, Object?>> fetchById(String tenantId);
}
