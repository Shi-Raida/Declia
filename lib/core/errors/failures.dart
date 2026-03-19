import 'package:declia/core/errors/app_exception.dart';

sealed class Failure {
  const Failure(this.message);
  final String message;

  factory Failure.fromException(AppException exception) => switch (exception) {
    NetworkException(:final message) => NetworkFailure(message),
    InvalidCredentialsException(:final message) => InvalidCredentialsFailure(
      message,
    ),
    UnauthorisedRoleException(:final message) => UnauthorisedRoleFailure(
      message,
    ),
    EmailAlreadyInUseException(:final message) => EmailAlreadyInUseFailure(
      message,
    ),
    NotFoundTenantException(:final message) => NotFoundTenantFailure(message),
    UnauthorisedTenantAccessException(:final message) =>
      UnauthorisedTenantAccessFailure(message),
    UserProfileNotFoundException(:final message) => UserProfileNotFoundFailure(
      message,
    ),
    SignUpFailedException(:final message) => SignUpFailedFailure(message),
    PasswordResetFailedException(:final message) => PasswordResetFailedFailure(
      message,
    ),
    RepositoryException(:final message) => RepositoryFailure(message),
    ClientNotFoundException(:final message) => ClientNotFoundFailure(message),
    UnauthorisedClientAccessException(:final message) =>
      UnauthorisedClientAccessFailure(message),
    GoogleCalendarException(:final message) => GoogleCalendarFailure(message),
  };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          message == other.message;

  @override
  int get hashCode => Object.hash(runtimeType, message);

  @override
  String toString() => '$runtimeType: $message';
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class InvalidCredentialsFailure extends Failure {
  const InvalidCredentialsFailure(super.message);
}

class UnauthorisedRoleFailure extends Failure {
  const UnauthorisedRoleFailure(super.message);
}

class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure(super.message);
}

class NotFoundTenantFailure extends Failure {
  const NotFoundTenantFailure(super.message);
}

class UnauthorisedTenantAccessFailure extends Failure {
  const UnauthorisedTenantAccessFailure(super.message);
}

class UserProfileNotFoundFailure extends Failure {
  const UserProfileNotFoundFailure(super.message);
}

class SignUpFailedFailure extends Failure {
  const SignUpFailedFailure(super.message);
}

class PasswordResetFailedFailure extends Failure {
  const PasswordResetFailedFailure(super.message);
}

class RepositoryFailure extends Failure {
  const RepositoryFailure(super.message);
}

class ClientNotFoundFailure extends Failure {
  const ClientNotFoundFailure(super.message);
}

class UnauthorisedClientAccessFailure extends Failure {
  const UnauthorisedClientAccessFailure(super.message);
}

class GoogleCalendarFailure extends Failure {
  const GoogleCalendarFailure(super.message);
}
