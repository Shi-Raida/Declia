import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/datasources/auth_data_source.dart';

final class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl({required AuthDataSource dataSource})
    : _dataSource = dataSource;

  final AuthDataSource _dataSource;

  @override
  bool get isAuthenticated => _dataSource.isAuthenticated;

  @override
  String? get currentUserId => _dataSource.currentUserId;

  @override
  Future<AppUser> signIn({required String email, required String password}) =>
      _dataSource.signIn(email: email, password: password);

  @override
  Future<void> signOut() => _dataSource.signOut();

  @override
  Future<AppUser?> getCurrentUser() => _dataSource.getCurrentUser();
}
