import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
import 'package:declia/domain/entities/app_user.dart';
import 'package:declia/domain/repositories/auth_repository.dart';
import 'package:declia/usecases/auth/sign_up.dart';
import 'package:flutter_test/flutter_test.dart';

final class _FakeAuthRepository implements AuthRepository {
  bool signUpCalled = false;
  bool shouldReturnEmailAlreadyInUse = false;

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
  }) async {
    if (shouldReturnEmailAlreadyInUse) {
      return const Err(EmailAlreadyInUseFailure('Email already in use'));
    }
    signUpCalled = true;
    return const Ok(null);
  }

  @override
  Future<Result<void, Failure>> resetPassword({required String email}) async =>
      throw UnimplementedError();
}

void main() {
  late _FakeAuthRepository repo;
  late SignUp signUp;

  setUp(() {
    repo = _FakeAuthRepository();
    signUp = SignUp(repo);
  });

  group('SignUp', () {
    test('returns Ok on success', () async {
      final result = await signUp((
        email: 'client@fleur.test',
        password: 'password123',
        tenantSlug: 'fleur-de-lumiere',
      ));

      expect(result, isA<Ok<void, Failure>>());
      expect(repo.signUpCalled, isTrue);
    });

    test('returns Err with EmailAlreadyInUseFailure', () async {
      repo.shouldReturnEmailAlreadyInUse = true;

      final result = await signUp((
        email: 'existing@fleur.test',
        password: 'password123',
        tenantSlug: 'fleur-de-lumiere',
      ));

      expect(result, isA<Err<void, Failure>>());
      expect((result as Err).error, isA<EmailAlreadyInUseFailure>());
    });
  });
}
