import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';

import '../entities/app_user.dart';

abstract interface class AuthRepository {
  Future<Result<AppUser, Failure>> signIn({
    required String email,
    required String password,
  });
  Future<Result<void, Failure>> signOut();
  Future<Result<AppUser?, Failure>> getCurrentUser();
  Future<Result<void, Failure>> signUp({
    required String email,
    required String password,
    required String tenantSlug,
  });
  Future<Result<void, Failure>> resetPassword({required String email});
  bool get isAuthenticated;
  String? get currentUserId;
}
