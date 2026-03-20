import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/repositories/google_calendar_repository.dart';
import '../usecase.dart';
import 'params.dart';

final class ToggleGoogleSync extends UseCase<void, ToggleSyncParams> {
  const ToggleGoogleSync(this._repository);

  final GoogleCalendarRepository _repository;

  @override
  Future<Result<void, Failure>> call(ToggleSyncParams params) =>
      _repository.toggleSync(id: params.id, enabled: params.enabled);
}
