import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/repositories/google_calendar_repository.dart';
import '../usecase.dart';

final class GetGoogleAuthUrl extends UseCase<String, NoParams> {
  const GetGoogleAuthUrl(this._repository);

  final GoogleCalendarRepository _repository;

  @override
  Future<Result<String, Failure>> call(NoParams params) =>
      _repository.getAuthUrl();
}
