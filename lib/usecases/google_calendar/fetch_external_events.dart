import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/external_calendar_event.dart';
import '../../domain/repositories/google_calendar_repository.dart';
import '../usecase.dart';
import 'params.dart';

final class FetchExternalEvents
    extends UseCase<List<ExternalCalendarEvent>, FetchExternalEventsParams> {
  const FetchExternalEvents(this._repository);

  final GoogleCalendarRepository _repository;

  @override
  Future<Result<List<ExternalCalendarEvent>, Failure>> call(
    FetchExternalEventsParams params,
  ) => _repository.fetchExternalEvents(start: params.start, end: params.end);
}
