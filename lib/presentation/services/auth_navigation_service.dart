import '../../core/enums/user_role.dart';

abstract interface class AuthNavigationService {
  void toLogin({String? reason});
  void toHome(UserRole role);
}
