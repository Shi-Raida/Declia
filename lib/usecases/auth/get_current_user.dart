import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../usecase.dart';

final class GetCurrentUser extends UseCase<AppUser?, NoParams> {
  const GetCurrentUser(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<AppUser?> call(NoParams params) => _authRepository.getCurrentUser();
}
