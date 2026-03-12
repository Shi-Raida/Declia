sealed class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => '$runtimeType: $message';
}

final class NetworkException extends AppException {
  const NetworkException(super.message);
}

final class NotFoundTenantException extends AppException {
  const NotFoundTenantException(this.tenantId)
    : super('Tenant not found: $tenantId');
  final String tenantId;
}

final class UnauthorisedTenantAccessException extends AppException {
  const UnauthorisedTenantAccessException()
    : super('Unauthorised access to tenant');
}

final class InvalidCredentialsException extends AppException {
  const InvalidCredentialsException() : super('Invalid email or password');
}

final class UnauthorisedRoleException extends AppException {
  const UnauthorisedRoleException(this.expectedRole)
    : super('Access denied: requires $expectedRole role');
  final String expectedRole;
}

final class UserProfileNotFoundException extends AppException {
  const UserProfileNotFoundException(this.userId)
    : super('User profile not found: $userId');
  final String userId;
}

final class RepositoryException extends AppException {
  const RepositoryException(super.message, {this.cause});
  final Object? cause;
}
