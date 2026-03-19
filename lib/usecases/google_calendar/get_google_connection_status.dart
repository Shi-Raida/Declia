import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/google_calendar_connection.dart';
import '../../domain/repositories/google_calendar_repository.dart';
import '../usecase.dart';

final class GetGoogleConnectionStatus
    extends UseCase<GoogleCalendarConnection?, NoParams> {
  const GetGoogleConnectionStatus(this._repository);

  final GoogleCalendarRepository _repository;

  @override
  Future<Result<GoogleCalendarConnection?, Failure>> call(NoParams params) =>
      _repository.getConnectionStatus();
}
