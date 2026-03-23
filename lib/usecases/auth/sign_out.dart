import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../usecase.dart';

final class SignOut extends UseCase<void, NoParams> {
  const SignOut(this._authRepository);

  final AuthCommands _authRepository;

  @override
  Future<Result<void, Failure>> call(NoParams params) =>
      _authRepository.signOut();
}
