import 'package:declia/core/enums/user_role.dart';
import 'package:declia/core/errors/app_exception.dart';
import 'package:declia/domain/entities/app_user.dart';
import 'package:declia/domain/repositories/auth_repository.dart';
import 'package:declia/usecases/auth/sign_in.dart';
import 'package:flutter_test/flutter_test.dart';

const _photographer = AppUser(
  id: '00000000-0000-0000-0001-000000000001',
  email: 'photo@fleur.test',
  tenantId: '00000000-0000-0000-0000-000000000001',
  role: UserRole.photographer,
);

const _client = AppUser(
  id: '00000000-0000-0000-0001-000000000002',
  email: 'client@fleur.test',
  tenantId: '00000000-0000-0000-0000-000000000001',
  role: UserRole.client,
);

final class _FakeAuthRepository implements AuthRepository {
  AppUser? userToReturn;
  bool signOutCalled = false;
  bool shouldThrowInvalidCredentials = false;

  @override
  bool get isAuthenticated => userToReturn != null;

  @override
  String? get currentUserId => userToReturn?.id;

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    if (shouldThrowInvalidCredentials) {
      throw const InvalidCredentialsException();
    }
    return userToReturn!;
  }

  @override
  Future<void> signOut() async {
    signOutCalled = true;
  }

  @override
  Future<AppUser?> getCurrentUser() async => userToReturn;
}

void main() {
  late _FakeAuthRepository repo;
  late SignIn signIn;

  setUp(() {
    repo = _FakeAuthRepository();
    signIn = SignIn(repo);
  });

  group('SignIn', () {
    test('returns user on successful authentication (photographer)', () async {
      repo.userToReturn = _photographer;

      final user = await signIn((
        email: 'photo@fleur.test',
        password: 'password123',
      ));

      expect(user.email, 'photo@fleur.test');
      expect(user.role, UserRole.photographer);
      expect(repo.signOutCalled, isFalse);
    });

    test('returns user on successful authentication (client)', () async {
      repo.userToReturn = _client;

      final user = await signIn((
        email: 'client@fleur.test',
        password: 'password123',
      ));

      expect(user.email, 'client@fleur.test');
      expect(user.role, UserRole.client);
      expect(repo.signOutCalled, isFalse);
    });

    test('throws InvalidCredentialsException on bad credentials', () async {
      repo.shouldThrowInvalidCredentials = true;

      expect(
        () => signIn((email: 'wrong@test.com', password: 'wrong')),
        throwsA(isA<InvalidCredentialsException>()),
      );
    });
  });
}
