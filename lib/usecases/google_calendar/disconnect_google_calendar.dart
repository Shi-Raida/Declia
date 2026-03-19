import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/repositories/google_calendar_repository.dart';
import '../usecase.dart';

final class DisconnectGoogleCalendar extends UseCase<void, NoParams> {
  const DisconnectGoogleCalendar(this._repository);

  final GoogleCalendarRepository _repository;

  @override
  Future<Result<void, Failure>> call(NoParams params) =>
      _repository.disconnect();
}
