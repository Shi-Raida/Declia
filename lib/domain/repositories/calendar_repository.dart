import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../entities/calendar_event.dart';

abstract interface class CalendarRepository {
  Future<Result<List<CalendarEvent>, Failure>> fetchByDateRange(
    DateTime start,
    DateTime end,
  );
}
