import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/enums/acquisition_source.dart';
import '../../core/enums/client_sort_field.dart';
import '../../core/enums/sort_direction.dart';
import '../../core/errors/app_exception.dart';
import '../../domain/entities/client.dart';
import '../../domain/entities/client_list_query.dart';
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
      final data = await _client.from('clients').select().eq('id', id).single();
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
      final data = await _client.from('clients').insert(json).select().single();
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
      final data = await _client.rpc(
        'search_clients',
        params: {'query': query},
      );
      return (data as List)
          .map((e) => Client.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, cause: e);
    }
  }

  @override
  Future<(List<Client>, int)> fetchList(ClientListQuery query) async {
    try {
      var q = _client.from('clients').select();

      if (query.search.isNotEmpty) {
        final s = query.search;
        q = q.or(
          'first_name.ilike.%$s%,last_name.ilike.%$s%'
          ',email.ilike.%$s%,phone.ilike.%$s%',
        );
      }
      if (query.tags.isNotEmpty) {
        q = q.contains('tags', query.tags);
      }
      if (query.acquisitionSource != null) {
        q = q.eq('acquisition_source', query.acquisitionSource!.jsonValue);
      }

      final asc = query.sortDirection == SortDirection.ascending;
      final from = query.page * query.pageSize;
      final to = from + query.pageSize - 1;

      final response = await switch (query.sortField) {
        ClientSortField.name =>
          q
              .order('last_name', ascending: asc)
              .order('first_name', ascending: asc)
              .range(from, to)
              .count(CountOption.exact),
        ClientSortField.createdAt =>
          q
              .order('created_at', ascending: asc)
              .range(from, to)
              .count(CountOption.exact),
      };

      final items = (response.data as List)
          .map((e) => Client.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
      return (items, (response.count as int?) ?? 0);
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, cause: e);
    }
  }

  @override
  Future<List<String>> fetchDistinctTags() async {
    try {
      final data = await _client.rpc('distinct_client_tags');
      return (data as List).cast<String>();
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, cause: e);
    }
  }
}
