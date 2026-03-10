import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../usecase.dart';

typedef SignInParams = ({String email, String password});

final class SignIn extends UseCase<AppUser, SignInParams> {
  const SignIn(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<AppUser> call(SignInParams params) {
    return _authRepository.signIn(
      email: params.email,
      password: params.password,
    );
  }
}
