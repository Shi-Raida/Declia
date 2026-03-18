import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/app_exception.dart';
import 'contract/tenant_data_source.dart';
import '../../domain/entities/tenant.dart';

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
  Future<Tenant> fetchCurrentUserTenant() async {
    try {
      final data = await _client.from('tenants').select().single();
      return Tenant.fromJson(Map<String, dynamic>.from(data));
    } on PostgrestException catch (e) {
      throw mapPostgrestException(e, '');
    }
  }

  @override
  Future<Tenant> fetchById(String id) async {
    try {
      final data = await _client.from('tenants').select().eq('id', id).single();
      return Tenant.fromJson(Map<String, dynamic>.from(data));
    } on PostgrestException catch (e) {
      throw mapPostgrestException(e, id);
    }
  }

  @override
  Future<bool> existsBySlug(String slug) async {
    try {
      final result = await _client.rpc(
        'tenant_exists_by_slug',
        params: {'p_slug': slug},
      );
      return result as bool;
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, cause: e);
    }
  }
}
