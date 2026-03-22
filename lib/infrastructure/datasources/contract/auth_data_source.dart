import '../../../domain/entities/app_user.dart';

abstract interface class AuthDataSource {
  Future<AppUser> signIn({required String email, required String password});
  Future<void> signOut();
  Future<AppUser?> getCurrentUser();
  Future<void> signUp({
    required String email,
    required String password,
    String? tenantSlug,
    Map<String, dynamic> metadata = const {},
  });
  Future<void> resetPassword({required String email});
  bool get isAuthenticated;
  String? get currentUserId;
}
