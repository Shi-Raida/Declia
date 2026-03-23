abstract interface class ShellNavigationService {
  String get currentRoute;
  void toDashboard();
  void toAdminPage(String route);
  void toClientHome();
  void toLegalPrivacy();
}
