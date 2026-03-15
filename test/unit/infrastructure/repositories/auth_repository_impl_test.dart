import 'package:declia/core/enums/user_role.dart';
import 'package:declia/core/errors/app_exception.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/repositories/repository_guard.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/infrastructure/datasources/contract/auth_data_source.dart';
import 'package:declia/domain/entities/app_user.dart';
import 'package:declia/infrastructure/repositories/auth_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';

const _userId = '00000000-0000-0000-0001-000000000001';
const _tenantId = '00000000-0000-0000-0000-000000000001';

const _fixturePhotographer = AppUser(
  id: _userId,
  email: 'photo@fleur.test',
  tenantId: _tenantId,
  role: UserRole.photographer,
);

final class _FakeAuthDataSource implements AuthDataSource {
  AppUser? userFixture;
  bool signUpCalled = false;
  bool resetPasswordCalled = false;

  @override
  bool get isAuthenticated => userFixture != null;

  @override
  String? get currentUserId => userFixture?.id;

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async => userFixture!;

  @override
  Future<void> signOut() async {
    userFixture = null;
  }

  @override
  Future<AppUser?> getCurrentUser() async => userFixture;

  @override
  Future<void> signUp({
    required String email,
    required String password,
    required String tenantSlug,
  }) async {
    signUpCalled = true;
  }

  @override
  Future<void> resetPassword({required String email}) async {
    resetPasswordCalled = true;
  }
}

/// A pass-through guard that wraps the action result in Ok,
/// or converts AppException to Err.
final class _PassthroughGuard implements RepositoryGuard {
  @override
  Future<Result<T, Failure>> call<T>(
    Future<T> Function() action, {
    required String method,
  }) async {
    try {
      return Ok(await action());
    } on AppException catch (e) {
      return Err(Failure.fromException(e));
    }
  }
}

AuthRepositoryImpl _makeRepo(_FakeAuthDataSource ds) =>
    AuthRepositoryImpl(dataSource: ds, guard: _PassthroughGuard());

void main() {
  group('AuthRepositoryImpl', () {
    test('signIn returns Ok with AppUser', () async {
      final ds = _FakeAuthDataSource()..userFixture = _fixturePhotographer;
      final repo = _makeRepo(ds);

      final result = await repo.signIn(
        email: 'photo@fleur.test',
        password: 'password123',
      );

      expect(result, isA<Ok<AppUser, Failure>>());
      final user = (result as Ok<AppUser, Failure>).value;
      expect(user.id, _userId);
      expect(user.email, 'photo@fleur.test');
      expect(user.tenantId, _tenantId);
      expect(user.role, UserRole.photographer);
    });

    test(
      'getCurrentUser returns Ok with AppUser when session exists',
      () async {
        final ds = _FakeAuthDataSource()..userFixture = _fixturePhotographer;
        final repo = _makeRepo(ds);

        final result = await repo.getCurrentUser();

        expect(result, isA<Ok<AppUser?, Failure>>());
        final user = (result as Ok<AppUser?, Failure>).value;
        expect(user, isNotNull);
        expect(user!.id, _userId);
        expect(user.email, 'photo@fleur.test');
        expect(user.role, UserRole.photographer);
      },
    );

    test('getCurrentUser returns Ok with null when no session', () async {
      final ds = _FakeAuthDataSource();
      final repo = _makeRepo(ds);

      final result = await repo.getCurrentUser();

      expect(result, isA<Ok<AppUser?, Failure>>());
      expect((result as Ok<AppUser?, Failure>).value, isNull);
    });

    test('isAuthenticated returns true when session exists', () {
      final ds = _FakeAuthDataSource()..userFixture = _fixturePhotographer;
      final repo = _makeRepo(ds);

      expect(repo.isAuthenticated, isTrue);
    });

    test('isAuthenticated returns false when no session', () {
      final ds = _FakeAuthDataSource();
      final repo = _makeRepo(ds);

      expect(repo.isAuthenticated, isFalse);
    });

    test('signUp delegates to data source', () async {
      final ds = _FakeAuthDataSource();
      final repo = _makeRepo(ds);

      await repo.signUp(
        email: 'client@fleur.test',
        password: 'password123',
        tenantSlug: 'fleur-de-lumiere',
      );

      expect(ds.signUpCalled, isTrue);
    });

    test('resetPassword delegates to data source', () async {
      final ds = _FakeAuthDataSource();
      final repo = _makeRepo(ds);

      await repo.resetPassword(email: 'client@fleur.test');

      expect(ds.resetPasswordCalled, isTrue);
    });
  });
}
