import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../usecase.dart';
import 'params.dart';

final class ResetPassword extends UseCase<void, ResetPasswordParams> {
  const ResetPassword(this._authRepository);

  final AuthCommands _authRepository;

  @override
  Future<Result<void, Failure>> call(ResetPasswordParams params) =>
      _authRepository.resetPassword(email: params.email);
}
