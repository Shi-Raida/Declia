import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/app_exception.dart';
import '../../domain/datasources/auth_data_source.dart';
import '../../domain/entities/app_user.dart';

final class SupabaseAuthDataSource implements AuthDataSource {
  const SupabaseAuthDataSource(this._client);

  final SupabaseClient _client;

  @override
  bool get isAuthenticated => _client.auth.currentUser != null;

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final userId = response.user!.id;
      final userData = await _client
          .from('users')
          .select('id, role, tenant_id')
          .eq('id', userId)
          .single();
      return AppUser.fromJson(<String, dynamic>{
        ...Map<String, Object?>.from(userData),
        'email': email,
      });
    } on AuthException {
      throw const InvalidCredentialsException();
    }
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final currentUser = _client.auth.currentUser;
    if (currentUser == null) return null;
    final userData = await _client
        .from('users')
        .select('id, role, tenant_id')
        .eq('id', currentUser.id)
        .single();
    return AppUser.fromJson(<String, dynamic>{
      ...Map<String, Object?>.from(userData),
      'email': currentUser.email,
    });
  }
}
