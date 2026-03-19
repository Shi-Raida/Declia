import 'package:supabase_flutter/supabase_flutter.dart' hide Session;

import '../../core/errors/app_exception.dart';
import 'contract/calendar_data_source.dart';

final class SupabaseCalendarDataSource implements CalendarDataSource {
  const SupabaseCalendarDataSource(this._client);

  final SupabaseClient _client;

  @override
  Future<List<Map<String, dynamic>>> fetchSessionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final data = await _client
          .from('sessions')
          .select('*, clients!inner(first_name, last_name)')
          .gte('scheduled_at', start.toIso8601String())
          .lte('scheduled_at', end.toIso8601String())
          .order('scheduled_at');
      return (data as List)
          .map((e) => Map<String, dynamic>.from(e as Map))
          .toList();
    } on PostgrestException catch (e) {
      throw RepositoryException(e.message, cause: e);
    }
  }
}
