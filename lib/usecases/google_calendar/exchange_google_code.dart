import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/repositories/google_calendar_repository.dart';
import '../usecase.dart';
import 'params.dart';

final class ExchangeGoogleCode extends UseCase<void, ExchangeCodeParams> {
  const ExchangeGoogleCode(this._repository);

  final GoogleCalendarRepository _repository;

  @override
  Future<Result<void, Failure>> call(ExchangeCodeParams params) =>
      _repository.exchangeCode(params.code);
}
