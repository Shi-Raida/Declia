import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/app_exception.dart';
import '../../domain/entities/external_calendar_event.dart';
import '../../domain/entities/google_calendar_connection.dart';
import 'contract/google_calendar_data_source.dart';

final class SupabaseGoogleCalendarDataSource
    implements GoogleCalendarDataSource {
  const SupabaseGoogleCalendarDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<String> getAuthUrl() async {
    try {
      final response = await _client.functions.invoke(
        'google-calendar-auth',
        body: {'action': 'get_auth_url'},
      );
      final data = response.data as Map<String, dynamic>;
      return data['url'] as String;
    } on FunctionException catch (e) {
      throw RepositoryException(e.details?.toString() ?? 'Failed to get auth URL', cause: e);
    }
  }

  @override
  Future<void> exchangeCode(String code) async {
    try {
      await _client.functions.invoke(
        'google-calendar-auth',
        body: {'action': 'exchange_code', 'code': code},
      );
    } on FunctionException catch (e) {
      throw RepositoryException(e.details?.toString() ?? 'Failed to exchange code', cause: e);
    }
  }

  @override
  Future<void> disconnect() async {
    try {
      await _client.functions.invoke(
        'google-calendar-auth',
        body: {'action': 'disconnect'},
      );
    } on FunctionException catch (e) {
      throw RepositoryException(e.details?.toString() ?? 'Failed to disconnect', cause: e);
    }
  }

  @override
  Future<GoogleCalendarConnection?> getConnectionStatus() async {
    try {
      final data = await _client
          .from('google_calendar_connections')
          .select('id, tenant_id, calendar_id, sync_enabled, last_sync_at, created_at, updated_at')
          .maybeSingle();
      if (data == null) return null;
      return GoogleCalendarConnection.fromJson(
        Map<String, dynamic>.from(data as Map),
      );
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, cause: e);
    }
  }

  @override
  Future<void> toggleSync({required bool enabled}) async {
    try {
      await _client
          .from('google_calendar_connections')
          .update({'sync_enabled': enabled});
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, cause: e);
    }
  }

  @override
  Future<void> triggerSync() async {
    try {
      await _client.functions.invoke('google-calendar-sync');
    } on FunctionException catch (e) {
      throw RepositoryException(e.details?.toString() ?? 'Sync failed', cause: e);
    }
  }

  @override
  Future<List<ExternalCalendarEvent>> fetchExternalEvents({
    required DateTime start,
    required DateTime end,
  }) async {
    try {
      final data = await _client
          .from('external_calendar_events')
          .select()
          .gte('start_at', start.toIso8601String())
          .lte('end_at', end.toIso8601String())
          .order('start_at');
      return (data as List)
          .map((e) => ExternalCalendarEvent.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList();
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, cause: e);
    }
  }
}
