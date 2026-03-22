import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/app_exception.dart';
import 'contract/auth_data_source.dart';
import '../../domain/entities/app_user.dart';

/// Maps an [AuthException] to a typed [AppException].
/// Package-level so it can be tested independently.
AppException mapAuthException(AuthException e) =>
    const InvalidCredentialsException();

/// Maps a [PostgrestException] from a user-profile query to a typed [AppException].
/// Package-level so it can be tested independently.
AppException mapAuthPostgrestException(PostgrestException e, String userId) {
  if (e.code == 'PGRST116') return UserProfileNotFoundException(userId);
  return RepositoryException(e.message, cause: e);
}

final class SupabaseAuthDataSource implements AuthDataSource {
  const SupabaseAuthDataSource(this._client);

  final SupabaseClient _client;

  @override
  bool get isAuthenticated => _client.auth.currentUser != null;

  @override
  String? get currentUserId => _client.auth.currentUser?.id;

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final String userId;
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      userId = response.user!.id;
    } on AuthException catch (e) {
      throw mapAuthException(e);
    }
    try {
      final userData = await _client
          .from('users')
          .select('id, role, tenant_id')
          .eq('id', userId)
          .single();
      return AppUser.fromJson(<String, dynamic>{
        ...Map<String, Object?>.from(userData),
        'email': email,
      });
    } on PostgrestException catch (e) {
      throw mapAuthPostgrestException(e, userId);
    }
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Future<void> signUp({
    required String email,
    required String password,
    String? tenantSlug,
    Map<String, dynamic> metadata = const {},
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          // ignore: use_null_aware_elements
          if (tenantSlug != null) 'tenant_slug': tenantSlug,
          ...metadata,
        },
      );
      // Supabase returns an empty identities list when email is already registered
      if (response.user?.identities?.isEmpty ?? false) {
        throw const EmailAlreadyInUseException();
      }
    } on EmailAlreadyInUseException {
      rethrow;
    } on AuthException catch (e) {
      throw SignUpFailedException(e.message);
    }
  }

  @override
  Future<void> resetPassword({required String email}) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } on AuthException catch (e) {
      throw PasswordResetFailedException(e.message);
    }
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) return null;
    try {
      final userData = await _client
          .from('users')
          .select('id, role, tenant_id')
          .eq('id', currentUser.id)
          .single();
      return AppUser.fromJson(<String, dynamic>{
        ...Map<String, Object?>.from(userData),
        'email': currentUser.email,
      });
    } on PostgrestException catch (e) {
      throw mapAuthPostgrestException(e, currentUser.id);
    }
  }
}
