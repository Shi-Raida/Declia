import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../usecase.dart';
import 'params.dart';

final class SignUp extends UseCase<void, SignUpParams> {
  const SignUp(this._authRepository);

  final AuthCommands _authRepository;

  @override
  Future<Result<void, Failure>> call(SignUpParams params) =>
      _authRepository.signUp(
        email: params.email,
        password: params.password,
        tenantSlug: params.tenantSlug,
        metadata: params.metadata,
      );
}
