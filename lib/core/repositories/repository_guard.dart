import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';

abstract interface class RepositoryGuard {
  Future<Result<T, Failure>> call<T>(
    Future<T> Function() action, {
    required String method,
  });
}
