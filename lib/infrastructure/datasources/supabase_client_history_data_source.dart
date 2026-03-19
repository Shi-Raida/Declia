import 'package:supabase_flutter/supabase_flutter.dart' hide Session;

import '../../core/errors/app_exception.dart';
import '../../domain/entities/communication_log.dart';
import '../../domain/entities/gallery.dart';
import '../../domain/entities/order.dart';
import '../../domain/entities/session.dart';
import 'contract/client_history_data_source.dart';

final class SupabaseClientHistoryDataSource implements ClientHistoryDataSource {
  const SupabaseClientHistoryDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Session>> fetchSessions(String clientId) async {
    try {
      final data = await _client
          .from('sessions')
          .select()
          .eq('client_id', clientId)
          .order('scheduled_at', ascending: false);
      return (data as List)
          .map((e) => Session.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, cause: e);
    }
  }

  @override
  Future<List<Gallery>> fetchGalleries(String clientId) async {
    try {
      final data = await _client
          .from('galleries')
          .select()
          .eq('client_id', clientId)
          .order('created_at', ascending: false);
      return (data as List)
          .map((e) => Gallery.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, cause: e);
    }
  }

  @override
  Future<List<Order>> fetchOrders(String clientId) async {
    try {
      final data = await _client
          .from('orders')
          .select()
          .eq('client_id', clientId)
          .order('order_date', ascending: false);
      return (data as List)
          .map((e) => Order.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, cause: e);
    }
  }

  @override
  Future<List<CommunicationLog>> fetchCommunicationLogs(String clientId) async {
    try {
      final data = await _client
          .from('communication_logs')
          .select()
          .eq('client_id', clientId)
          .order('created_at', ascending: false);
      return (data as List)
          .map(
            (e) =>
                CommunicationLog.fromJson(Map<String, dynamic>.from(e as Map)),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, cause: e);
    }
  }

  @override
  Future<Map<String, Map<String, dynamic>>> fetchSummaryStats(
    List<String> clientIds,
  ) async {
    if (clientIds.isEmpty) return {};
    try {
      final data = await _client
          .from('client_summary_stats')
          .select()
          .inFilter('client_id', clientIds);
      return {
        for (final row in (data as List))
          (row as Map)['client_id'] as String: Map<String, dynamic>.from(row),
      };
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, cause: e);
    }
  }
}
