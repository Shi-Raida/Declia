import 'package:declia/core/enums/user_role.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:declia/core/utils/result.dart';
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
  bool shouldReturnInvalidCredentials = false;

  @override
  bool get isAuthenticated => userToReturn != null;

  @override
  String? get currentUserId => userToReturn?.id;

  @override
  Future<Result<AppUser, Failure>> signIn({
    required String email,
    required String password,
  }) async {
    if (shouldReturnInvalidCredentials) {
      return const Err(InvalidCredentialsFailure('Invalid email or password'));
    }
    return Ok(userToReturn!);
  }

  @override
  Future<Result<void, Failure>> signOut() async {
    signOutCalled = true;
    return const Ok(null);
  }

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
  late _FakeAuthRepository repo;
  late SignIn signIn;

  setUp(() {
    repo = _FakeAuthRepository();
    signIn = SignIn(repo);
  });

  group('SignIn', () {
    test(
      'returns Ok with user on successful authentication (photographer)',
      () async {
        repo.userToReturn = _photographer;

        final result = await signIn((
          email: 'photo@fleur.test',
          password: 'password123',
          allowedRoles: {UserRole.photographer},
        ));

        expect(result, isA<Ok<AppUser, Failure>>());
        final ok1 = result as Ok<AppUser, Failure>;
        expect(ok1.value.email, 'photo@fleur.test');
        expect(ok1.value.role, UserRole.photographer);
        expect(repo.signOutCalled, isFalse);
      },
    );

    test(
      'returns Ok with user on successful authentication (client)',
      () async {
        repo.userToReturn = _client;

        final result = await signIn((
          email: 'client@fleur.test',
          password: 'password123',
          allowedRoles: {UserRole.client},
        ));

        expect(result, isA<Ok<AppUser, Failure>>());
        final ok2 = result as Ok<AppUser, Failure>;
        expect(ok2.value.email, 'client@fleur.test');
        expect(ok2.value.role, UserRole.client);
        expect(repo.signOutCalled, isFalse);
      },
    );

    test(
      'returns Err with InvalidCredentialsFailure on bad credentials',
      () async {
        repo.shouldReturnInvalidCredentials = true;

        final result = await signIn((
          email: 'wrong@test.com',
          password: 'wrong',
          allowedRoles: {UserRole.photographer},
        ));

        expect(result, isA<Err<AppUser, Failure>>());
        expect((result as Err).error, isA<InvalidCredentialsFailure>());
      },
    );

    test(
      'returns Err with UnauthorisedRoleFailure and signs out when role not allowed',
      () async {
        repo.userToReturn = _client;

        final result = await signIn((
          email: 'client@fleur.test',
          password: 'password123',
          allowedRoles: {UserRole.photographer},
        ));

        expect(result, isA<Err<AppUser, Failure>>());
        expect((result as Err).error, isA<UnauthorisedRoleFailure>());
        expect(repo.signOutCalled, isTrue);
      },
    );

    test(
      'allows user when role matches one of multiple allowedRoles',
      () async {
        repo.userToReturn = _photographer;

        final result = await signIn((
          email: 'photo@fleur.test',
          password: 'password123',
          allowedRoles: {UserRole.photographer, UserRole.client},
        ));

        expect(result, isA<Ok<AppUser, Failure>>());
        expect(repo.signOutCalled, isFalse);
      },
    );
  });
}
