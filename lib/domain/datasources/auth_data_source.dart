import '../entities/app_user.dart';

abstract interface class AuthDataSource {
  Future<AppUser> signIn({required String email, required String password});
  Future<void> signOut();
  Future<AppUser?> getCurrentUser();
  bool get isAuthenticated;
}
