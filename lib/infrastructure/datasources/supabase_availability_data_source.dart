import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/app_exception.dart';
import '../../domain/entities/availability_rule.dart';
import 'contract/availability_data_source.dart';

final class SupabaseAvailabilityDataSource implements AvailabilityDataSource {
  const SupabaseAvailabilityDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<List<AvailabilityRule>> fetchAll() async {
    try {
      final data = await _client
          .from('availability_rules')
          .select()
          .order('created_at');
      return (data as List)
          .map(
            (e) =>
                AvailabilityRule.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, cause: e);
    }
  }

  @override
  Future<AvailabilityRule> create(AvailabilityRule rule) async {
    try {
      final json = rule.toJson()
        ..remove('id')
        ..remove('tenant_id')
        ..remove('created_at')
        ..remove('updated_at');
      final data = await _client
          .from('availability_rules')
          .insert(json)
          .select()
          .single();
      return AvailabilityRule.fromJson(Map<String, dynamic>.from(data));
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, cause: e);
    }
  }

  @override
  Future<AvailabilityRule> update(AvailabilityRule rule) async {
    try {
      final json = rule.toJson()
        ..remove('id')
        ..remove('tenant_id')
        ..remove('created_at')
        ..remove('updated_at');
      final data = await _client
          .from('availability_rules')
          .update(json)
          .eq('id', rule.id)
          .select()
          .single();
      return AvailabilityRule.fromJson(Map<String, dynamic>.from(data));
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, cause: e);
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _client.from('availability_rules').delete().eq('id', id);
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, cause: e);
    }
  }
}
