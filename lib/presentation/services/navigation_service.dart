import '../../core/enums/user_role.dart';

abstract interface class NavigationService {
  String get currentRoute;
  void toLogin({String? reason});
  void toHome(UserRole role);
  void toDashboard();
  void toAdminPage(String route);
  void toClientLogin();
  void toClientHome();
  void toClientRegister({required String tenantSlug});
  void toClientForgotPassword();
}
