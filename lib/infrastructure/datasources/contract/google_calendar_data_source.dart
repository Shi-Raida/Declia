import '../../../domain/entities/external_calendar_event.dart';
import '../../../domain/entities/google_calendar_connection.dart';

abstract interface class GoogleCalendarDataSource {
  Future<String> getAuthUrl();
  Future<void> exchangeCode(String code);
  Future<void> disconnect();
  Future<GoogleCalendarConnection?> getConnectionStatus();
  Future<void> toggleSync({required String id, required bool enabled});
  Future<void> triggerSync();
  Future<List<ExternalCalendarEvent>> fetchExternalEvents({
    required DateTime start,
    required DateTime end,
  });
}
