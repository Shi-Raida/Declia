import '../../core/enums/user_role.dart';
import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../usecase.dart';
import 'params.dart';

final class SignIn extends UseCase<AppUser, SignInParams> {
  const SignIn(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Result<AppUser, Failure>> call(SignInParams params) async {
    final result = await _authRepository.signIn(
      email: params.email,
      password: params.password,
    );
    return switch (result) {
      Err() => result,
      Ok(:final value) =>
        params.allowedRoles.contains(value.role)
            ? result
            : await _signOutAndReject(params.allowedRoles),
    };
  }

  Future<Result<AppUser, Failure>> _signOutAndReject(
    Set<UserRole> roles,
  ) async {
    await _authRepository.signOut();
    return Err(UnauthorisedRoleFailure(roles.toString()));
  }
}
