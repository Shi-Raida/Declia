import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/app_user.dart';
import 'package:declia/domain/repositories/auth_repository.dart';
import 'package:declia/usecases/auth/reset_password.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeAuthRepository implements AuthRepository {
  bool resetPasswordCalled = false;
  bool shouldReturnPasswordResetFailed = false;

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
  Future<Result<void, Failure>> signOut() async => const Ok(null);

  @override
  Future<Result<AppUser?, Failure>> getCurrentUser() async => const Ok(null);

  @override
  Future<Result<void, Failure>> signUp({
    required String email,
    required String password,
    required String tenantSlug,
  }) async => throw UnimplementedError();

  @override
  Future<Result<void, Failure>> resetPassword({required String email}) async {
    if (shouldReturnPasswordResetFailed) {
      return const Err(PasswordResetFailedFailure('Reset failed'));
    }
    resetPasswordCalled = true;
    return const Ok(null);
  }
}

void main() {
  late _FakeAuthRepository repo;
  late ResetPassword resetPassword;

  setUp(() {
    repo = _FakeAuthRepository();
    resetPassword = ResetPassword(repo);
  });

  group('ResetPassword', () {
    test('returns Ok on success', () async {
      final result = await resetPassword((email: 'client@fleur.test'));

      expect(result, isA<Ok<void, Failure>>());
      expect(repo.resetPasswordCalled, isTrue);
    });

    test('returns Err with PasswordResetFailedFailure', () async {
      repo.shouldReturnPasswordResetFailed = true;

      final result = await resetPassword((email: 'client@fleur.test'));

      expect(result, isA<Err<void, Failure>>());
      expect((result as Err).error, isA<PasswordResetFailedFailure>());
    });
  });
}
