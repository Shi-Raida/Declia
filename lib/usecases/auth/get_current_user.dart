import '../../core/errors/failures.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../usecase.dart';

typedef GetCurrentUserUseCase = UseCase<AppUser?, NoParams>;

final class GetCurrentUser extends UseCase<AppUser?, NoParams> {
  const GetCurrentUser(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Future<Result<AppUser?, Failure>> call(NoParams params) =>
      _authRepository.getCurrentUser();
}
