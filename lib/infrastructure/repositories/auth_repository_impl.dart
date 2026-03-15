import '../../core/errors/failures.dart';
import '../../core/repositories/repository_guard.dart';
import '../../core/utils/result.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/contract/auth_data_source.dart';

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({
    required AuthDataSource dataSource,
    required RepositoryGuard guard,
  }) : _dataSource = dataSource,
       _guard = guard;

  final AuthDataSource _dataSource;
  final RepositoryGuard _guard;

  @override
  bool get isAuthenticated => _dataSource.isAuthenticated;

  @override
  String? get currentUserId => _dataSource.currentUserId;

  @override
  Future<Result<AppUser, Failure>> signIn({
    required String email,
    required String password,
  }) => _guard(
    () => _dataSource.signIn(email: email, password: password),
    method: 'signIn',
  );

  @override
  Future<Result<void, Failure>> signOut() =>
      _guard(() => _dataSource.signOut(), method: 'signOut');

  @override
  Future<Result<AppUser?, Failure>> getCurrentUser() =>
      _guard(() => _dataSource.getCurrentUser(), method: 'getCurrentUser');

  @override
  Future<Result<void, Failure>> signUp({
    required String email,
    required String password,
    required String tenantSlug,
  }) => _guard(
    () => _dataSource.signUp(
      email: email,
      password: password,
      tenantSlug: tenantSlug,
    ),
    method: 'signUp',
  );

  @override
  Future<Result<void, Failure>> resetPassword({required String email}) =>
      _guard(
        () => _dataSource.resetPassword(email: email),
        method: 'resetPassword',
      );
}
