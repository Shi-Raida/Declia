import 'package:declia/domain/entities/app_user.dart';
import 'package:declia/domain/repositories/auth_repository.dart';
import 'package:declia/usecases/auth/sign_out.dart';
import 'package:declia/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeAuthRepository implements AuthRepository {
  bool signOutCalled = false;

  @override
  AppUser? get cachedUser => null;

  @override
  bool get isAuthenticated => false;

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    signOutCalled = true;
  }

  @override
  Future<AppUser?> getCurrentUser() async => null;
}

void main() {
  group('SignOut', () {
    test('delegates to repository', () async {
      final repo = _FakeAuthRepository();
      final signOut = SignOut(repo);

      await signOut(const NoParams());

      expect(repo.signOutCalled, isTrue);
    });
  });
}
