import 'package:declia/core/errors/app_exception.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/logger/app_logger.dart';
import 'package:declia/core/repositories/repository_guard.dart';
import 'package:declia/core/utils/result.dart';

class AuthRepositoryGuard implements RepositoryGuard {
  AuthRepositoryGuard(this._logger);

  final AppLogger _logger;

  @override
  Future<Result<T, Failure>> call<T>(
    Future<T> Function() action, {
    required String method,
  }) async {
    try {
      return Ok(await action());
    } on AppException catch (e) {
      _logger.warning('$method failed', error: e);
      return Err(Failure.fromException(e));
    }
  }
}
