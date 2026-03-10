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

final class RepositoryException extends AppException {
  const RepositoryException(super.message, {this.cause});
  final Object? cause;
}
