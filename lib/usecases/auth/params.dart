import '../../core/enums/user_role.dart';
import '../../domain/entities/app_user.dart';
import '../usecase.dart';

typedef SignInParams = ({
  String email,
  String password,
  Set<UserRole> allowedRoles,
});
typedef SignUpParams = ({String email, String password, String tenantSlug});
typedef ResetPasswordParams = ({String email});
typedef SignInUseCase = UseCase<AppUser, SignInParams>;
typedef GetCurrentUserUseCase = UseCase<AppUser?, NoParams>;
