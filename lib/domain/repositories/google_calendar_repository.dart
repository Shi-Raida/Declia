import '../../core/utils/result.dart';
import '../../core/errors/failures.dart';
import '../entities/external_calendar_event.dart';
import '../entities/google_calendar_connection.dart';

abstract interface class GoogleCalendarRepository {
  Future<Result<String, Failure>> getAuthUrl();
  Future<Result<void, Failure>> exchangeCode(String code);
  Future<Result<void, Failure>> disconnect();
  Future<Result<GoogleCalendarConnection?, Failure>> getConnectionStatus();
  Future<Result<void, Failure>> toggleSync({required bool enabled});
  Future<Result<void, Failure>> triggerSync();
  Future<Result<List<ExternalCalendarEvent>, Failure>> fetchExternalEvents({
    required DateTime start,
    required DateTime end,
  });
}
