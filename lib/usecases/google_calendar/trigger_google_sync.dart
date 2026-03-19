import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/repositories/google_calendar_repository.dart';
import '../usecase.dart';

final class TriggerGoogleSync extends UseCase<void, NoParams> {
  const TriggerGoogleSync(this._repository);

  final GoogleCalendarRepository _repository;

  @override
  Future<Result<void, Failure>> call(NoParams params) =>
      _repository.triggerSync();
}
