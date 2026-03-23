import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';

import '../entities/app_user.dart';

abstract interface class AuthStateReader {
  bool get isAuthenticated;
  String? get currentUserId;
  Future<Result<AppUser?, Failure>> getCurrentUser();
}

abstract interface class AuthCommands {
  Future<Result<AppUser, Failure>> signIn({
    required String email,
    required String password,
  });
  Future<Result<void, Failure>> signOut();
  Future<Result<void, Failure>> signUp({
    required String email,
    required String password,
    String? tenantSlug,
    Map<String, dynamic> metadata = const {},
  });
  Future<Result<void, Failure>> resetPassword({required String email});
}

abstract interface class AuthRepository
    implements AuthStateReader, AuthCommands {}
