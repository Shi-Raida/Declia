import '../../domain/repositories/auth_repository.dart';
import '../usecase.dart';

final class SignOut extends UseCase<void, NoParams> {
  const SignOut(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<void> call(NoParams params) => _authRepository.signOut();
}
