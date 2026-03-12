import 'package:declia/core/enums/user_role.dart';
import 'package:declia/domain/entities/app_user.dart';
import 'package:declia/domain/repositories/auth_repository.dart';
import 'package:declia/usecases/auth/get_current_user.dart';
import 'package:declia/usecases/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

const _photographer = AppUser(
  id: '00000000-0000-0000-0001-000000000001',
  email: 'photo@fleur.test',
  tenantId: '00000000-0000-0000-0000-000000000001',
  role: UserRole.photographer,
);

final class _FakeAuthRepository implements AuthRepository {
  AppUser? userToReturn;

  @override
  bool get isAuthenticated => userToReturn != null;

  @override
  String? get currentUserId => userToReturn?.id;

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {}

  @override
  Future<AppUser?> getCurrentUser() async => userToReturn;
}

void main() {
  group('GetCurrentUser', () {
    test('returns user when session exists', () async {
      final repo = _FakeAuthRepository()..userToReturn = _photographer;
      final getCurrentUser = GetCurrentUser(repo);

      final user = await getCurrentUser(const NoParams());

      expect(user, isNotNull);
      expect(user!.email, 'photo@fleur.test');
      expect(user.role, UserRole.photographer);
    });

    test('returns null when no session', () async {
      final repo = _FakeAuthRepository();
      final getCurrentUser = GetCurrentUser(repo);

      final user = await getCurrentUser(const NoParams());

      expect(user, isNull);
    });
  });
}
