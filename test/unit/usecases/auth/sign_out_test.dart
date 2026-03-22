import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/app_user.dart';
import 'package:declia/domain/repositories/auth_repository.dart';
import 'package:declia/usecases/auth/sign_out.dart';
import 'package:declia/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeAuthRepository implements AuthRepository {
  bool signOutCalled = false;

  @override
  bool get isAuthenticated => false;

  @override
  String? get currentUserId => null;

  @override
  Future<Result<AppUser, Failure>> signIn({
    required String email,
    required String password,
  }) async => throw UnimplementedError();

  @override
  Future<Result<void, Failure>> signOut() async {
    signOutCalled = true;
    return const Ok(null);
  }

  @override
  Future<Result<AppUser?, Failure>> getCurrentUser() async => const Ok(null);

  @override
  Future<Result<void, Failure>> signUp({
    required String email,
    required String password,
    String? tenantSlug,
    Map<String, dynamic> metadata = const {},
  }) async => throw UnimplementedError();

  @override
  Future<Result<void, Failure>> resetPassword({required String email}) async =>
      throw UnimplementedError();
}

void main() {
  group('SignOut', () {
    test('delegates to repository', () async {
      final repo = _FakeAuthRepository();
      final signOut = SignOut(repo);

      final result = await signOut(const NoParams());

      expect(result, isA<Ok<void, Failure>>());
      expect(repo.signOutCalled, isTrue);
    });
  });
}
