import 'package:declia/core/enums/user_role.dart';
import 'package:declia/domain/datasources/auth_data_source.dart';
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

  @override
  bool get isAuthenticated => userFixture != null;

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    return userFixture!;
  }

  @override
  Future<void> signOut() async {
    userFixture = null;
  }

  @override
  Future<AppUser?> getCurrentUser() async => userFixture;
}

void main() {
  group('AuthRepositoryImpl', () {
    test('signIn maps JSON to AppUser', () async {
      final ds = _FakeAuthDataSource()..userFixture = _fixturePhotographer;
      final repo = AuthRepositoryImpl(dataSource: ds);

      final user = await repo.signIn(
        email: 'photo@fleur.test',
        password: 'password123',
      );

      expect(user.id, _userId);
      expect(user.email, 'photo@fleur.test');
      expect(user.tenantId, _tenantId);
      expect(user.role, UserRole.photographer);
    });

    test('getCurrentUser maps JSON to AppUser when session exists', () async {
      final ds = _FakeAuthDataSource()..userFixture = _fixturePhotographer;
      final repo = AuthRepositoryImpl(dataSource: ds);

      final user = await repo.getCurrentUser();

      expect(user, isNotNull);
      expect(user!.id, _userId);
      expect(user.email, 'photo@fleur.test');
      expect(user.role, UserRole.photographer);
    });

    test('getCurrentUser returns null when no session', () async {
      final ds = _FakeAuthDataSource();
      final repo = AuthRepositoryImpl(dataSource: ds);

      final user = await repo.getCurrentUser();

      expect(user, isNull);
    });

    test('isAuthenticated returns true when session exists', () {
      final ds = _FakeAuthDataSource()..userFixture = _fixturePhotographer;
      final repo = AuthRepositoryImpl(dataSource: ds);

      expect(repo.isAuthenticated, isTrue);
    });

    test('isAuthenticated returns false when no session', () {
      final ds = _FakeAuthDataSource();
      final repo = AuthRepositoryImpl(dataSource: ds);

      expect(repo.isAuthenticated, isFalse);
    });

    test('cachedUser is null before any operation', () {
      final ds = _FakeAuthDataSource()..userFixture = _fixturePhotographer;
      final repo = AuthRepositoryImpl(dataSource: ds);

      expect(repo.cachedUser, isNull);
    });

    test('cachedUser is populated after signIn', () async {
      final ds = _FakeAuthDataSource()..userFixture = _fixturePhotographer;
      final repo = AuthRepositoryImpl(dataSource: ds);

      await repo.signIn(email: 'photo@fleur.test', password: 'password123');

      expect(repo.cachedUser, isNotNull);
      expect(repo.cachedUser!.email, 'photo@fleur.test');
    });

    test('cachedUser is populated after getCurrentUser', () async {
      final ds = _FakeAuthDataSource()..userFixture = _fixturePhotographer;
      final repo = AuthRepositoryImpl(dataSource: ds);

      await repo.getCurrentUser();

      expect(repo.cachedUser, isNotNull);
      expect(repo.cachedUser!.email, 'photo@fleur.test');
    });

    test('cachedUser is cleared after signOut', () async {
      final ds = _FakeAuthDataSource()..userFixture = _fixturePhotographer;
      final repo = AuthRepositoryImpl(dataSource: ds);

      await repo.signIn(email: 'photo@fleur.test', password: 'password123');
      expect(repo.cachedUser, isNotNull);

      await repo.signOut();

      expect(repo.cachedUser, isNull);
    });

    test('cachedUser is null when getCurrentUser returns null', () async {
      final ds = _FakeAuthDataSource();
      final repo = AuthRepositoryImpl(dataSource: ds);

      await repo.getCurrentUser();

      expect(repo.cachedUser, isNull);
    });
  });
}
