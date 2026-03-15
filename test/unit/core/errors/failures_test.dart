import 'package:declia/core/errors/app_exception.dart';
import 'package:declia/core/errors/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure.fromException', () {
    test('NetworkException → NetworkFailure', () {
      const e = NetworkException('no network');
      expect(Failure.fromException(e), const NetworkFailure('no network'));
    });

    test('InvalidCredentialsException → InvalidCredentialsFailure', () {
      const e = InvalidCredentialsException();
      expect(
        Failure.fromException(e),
        const InvalidCredentialsFailure('Invalid email or password'),
      );
    });

    test('UnauthorisedRoleException → UnauthorisedRoleFailure', () {
      const e = UnauthorisedRoleException('{photographer}');
      expect(
        Failure.fromException(e),
        const UnauthorisedRoleFailure(
          'Access denied: requires {photographer} role',
        ),
      );
    });

    test('EmailAlreadyInUseException → EmailAlreadyInUseFailure', () {
      const e = EmailAlreadyInUseException();
      expect(
        Failure.fromException(e),
        const EmailAlreadyInUseFailure('Email already in use'),
      );
    });

    test('NotFoundTenantException → NotFoundTenantFailure', () {
      const e = NotFoundTenantException('t1');
      expect(
        Failure.fromException(e),
        const NotFoundTenantFailure('Tenant not found: t1'),
      );
    });

    test(
      'UnauthorisedTenantAccessException → UnauthorisedTenantAccessFailure',
      () {
        const e = UnauthorisedTenantAccessException();
        expect(
          Failure.fromException(e),
          const UnauthorisedTenantAccessFailure(
            'Unauthorised access to tenant',
          ),
        );
      },
    );

    test('UserProfileNotFoundException → UserProfileNotFoundFailure', () {
      const e = UserProfileNotFoundException('u1');
      expect(
        Failure.fromException(e),
        const UserProfileNotFoundFailure('User profile not found: u1'),
      );
    });

    test('SignUpFailedException → SignUpFailedFailure', () {
      const e = SignUpFailedException('signup error');
      expect(
        Failure.fromException(e),
        const SignUpFailedFailure('signup error'),
      );
    });

    test('PasswordResetFailedException → PasswordResetFailedFailure', () {
      const e = PasswordResetFailedException('reset error');
      expect(
        Failure.fromException(e),
        const PasswordResetFailedFailure('reset error'),
      );
    });

    test('RepositoryException → RepositoryFailure', () {
      const e = RepositoryException('repo error');
      expect(Failure.fromException(e), const RepositoryFailure('repo error'));
    });
  });

  group('Failure equality', () {
    test('same type and message are equal', () {
      expect(const NetworkFailure('a') == const NetworkFailure('a'), isTrue);
    });

    test('same type different message are not equal', () {
      expect(const NetworkFailure('a') == const NetworkFailure('b'), isFalse);
    });

    test('different types are not equal', () {
      expect(
        const NetworkFailure('a') == const RepositoryFailure('a'),
        isFalse,
      );
    });
  });
}
