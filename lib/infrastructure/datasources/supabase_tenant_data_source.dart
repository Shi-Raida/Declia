import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/app_exception.dart';
import 'tenant_data_source.dart';

/// Maps a [PostgrestException] to a typed [AppException].
/// Package-level so it can be tested independently.
AppException mapPostgrestException(PostgrestException e, String id) {
  if (e.code == 'PGRST116') return NotFoundTenantException(id);
  if (e.code == '42501') return const UnauthorisedTenantAccessException();
  return RepositoryException(e.message, cause: e);
}

final class SupabaseTenantDataSource implements TenantDataSource {
  const SupabaseTenantDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<Map<String, Object?>> fetchCurrentUserTenant() async {
    try {
      final data = await _client.from('tenants').select().single();
      return Map<String, Object?>.from(data);
    } on PostgrestException catch (e) {
      throw mapPostgrestException(e, '');
    }
  }

  @override
  Future<Map<String, Object?>> fetchById(String tenantId) async {
    try {
      final data = await _client
          .from('tenants')
          .select()
          .eq('id', tenantId)
          .single();
      return Map<String, Object?>.from(data);
    } on PostgrestException catch (e) {
      throw mapPostgrestException(e, tenantId);
    }
  }
}
