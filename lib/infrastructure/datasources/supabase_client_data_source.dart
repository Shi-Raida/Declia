import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/app_exception.dart';
import '../../domain/entities/client.dart';
import 'contract/client_data_source.dart';

/// Maps a [PostgrestException] to a typed [AppException] for client operations.
/// Package-level so it can be tested independently.
AppException mapClientPostgrestException(PostgrestException e, String id) {
  if (e.code == 'PGRST116') return ClientNotFoundException(id);
  if (e.code == '42501') return const UnauthorisedClientAccessException();
  return RepositoryException(e.message, cause: e);
}

final class SupabaseClientDataSource implements ClientDataSource {
  const SupabaseClientDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Client>> fetchAll() async {
    try {
      final data = await _client
          .from('clients')
          .select()
          .order('last_name')
          .order('first_name');
      return (data as List)
          .map((e) => Client.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, cause: e);
    }
  }

  @override
  Future<Client> fetchById(String id) async {
    try {
      final data = await _client
          .from('clients')
          .select()
          .eq('id', id)
          .single();
      return Client.fromJson(Map<String, dynamic>.from(data));
    } on PostgrestException catch (e) {
      throw mapClientPostgrestException(e, id);
    }
  }

  @override
  Future<Client> create(Client client) async {
    try {
      final json = client.toJson()
        ..remove('id')
        ..remove('tenant_id') // set by DB DEFAULT (current_user_tenant_id())
        ..remove('created_at')
        ..remove('updated_at');
      final data = await _client
          .from('clients')
          .insert(json)
          .select()
          .single();
      return Client.fromJson(Map<String, dynamic>.from(data));
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, cause: e);
    }
  }

  @override
  Future<Client> update(Client client) async {
    try {
      final json = client.toJson()
        ..remove('id')
        ..remove('tenant_id')
        ..remove('created_at')
        ..remove('updated_at');
      final data = await _client
          .from('clients')
          .update(json)
          .eq('id', client.id)
          .select()
          .single();
      return Client.fromJson(Map<String, dynamic>.from(data));
    } on PostgrestException catch (e) {
      throw mapClientPostgrestException(e, client.id);
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _client.from('clients').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw mapClientPostgrestException(e, id);
    }
  }

  @override
  Future<List<Client>> search(String query) async {
    try {
      final data = await _client
          .rpc('search_clients', params: {'query': query});
      return (data as List)
          .map((e) => Client.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, cause: e);
    }
  }
}
