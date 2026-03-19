import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/calendar_event.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../usecase.dart';
import 'params.dart';

final class FetchCalendarSessions
    extends UseCase<List<CalendarEvent>, FetchCalendarSessionsParams> {
  const FetchCalendarSessions(this._repository);

  final CalendarRepository _repository;

  @override
  Future<Result<List<CalendarEvent>, Failure>> call(
    FetchCalendarSessionsParams params,
  ) => _repository.fetchByDateRange(params.start, params.end);
}
