abstract interface class NavigationService {
  void toLogin({String? reason});
  void toDashboard();
  void toClientLogin();
  void toClientHome();
  void toClientRegister({required String tenantSlug});
  void toClientForgotPassword();
}
