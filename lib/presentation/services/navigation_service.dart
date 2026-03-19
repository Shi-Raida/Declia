import '../../core/enums/user_role.dart';

abstract interface class NavigationService {
  String get currentRoute;
  void toLogin({String? reason});
  void toHome(UserRole role);
  void toDashboard();
  void toAdminPage(String route);
  void toClientLogin({String? tenantSlug});
  void toClientHome();
  void toClientRegister({String? tenantSlug});
  void toClientForgotPassword();
  void toLegalPrivacy();
  void toClientDetail(String id, {dynamic arguments});
  void toClientEdit(String id, {dynamic arguments});
  void toClientNew();
  void goBack();
}
