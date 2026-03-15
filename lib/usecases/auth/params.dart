import '../../core/enums/user_role.dart';

typedef SignInParams = ({
  String email,
  String password,
  Set<UserRole> allowedRoles,
});
typedef SignUpParams = ({String email, String password, String tenantSlug});
typedef ResetPasswordParams = ({String email});
