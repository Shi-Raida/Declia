import 'package:declia/core/enums/user_role.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
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
  Future<Result<AppUser, Failure>> signIn({
    required String email,
    required String password,
  }) async => throw UnimplementedError();

  @override
  Future<Result<void, Failure>> signOut() async => const Ok(null);

  @override
  Future<Result<AppUser?, Failure>> getCurrentUser() async => Ok(userToReturn);

  @override
  Future<Result<void, Failure>> signUp({
    required String email,
    required String password,
    required String tenantSlug,
  }) async => throw UnimplementedError();

  @override
  Future<Result<void, Failure>> resetPassword({required String email}) async =>
      throw UnimplementedError();
}

void main() {
  group('GetCurrentUser', () {
    test('returns Ok with user when session exists', () async {
      final repo = _FakeAuthRepository()..userToReturn = _photographer;
      final getCurrentUser = GetCurrentUser(repo);

      final result = await getCurrentUser(const NoParams());

      expect(result, isA<Ok<AppUser?, Failure>>());
      final user = (result as Ok<AppUser?, Failure>).value;
      expect(user, isNotNull);
      expect(user!.email, 'photo@fleur.test');
      expect(user.role, UserRole.photographer);
    });

    test('returns Ok with null when no session', () async {
      final repo = _FakeAuthRepository();
      final getCurrentUser = GetCurrentUser(repo);

      final result = await getCurrentUser(const NoParams());

      expect(result, isA<Ok<AppUser?, Failure>>());
      expect((result as Ok<AppUser?, Failure>).value, isNull);
    });
  });
}
