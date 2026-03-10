import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/datasources/auth_data_source.dart';

final class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({required AuthDataSource dataSource})
    : _dataSource = dataSource;

  final AuthDataSource _dataSource;
  AppUser? _cachedUser;

  @override
  bool get isAuthenticated => _dataSource.isAuthenticated;

  AppUser? get cachedUser => _cachedUser;

  @override
  Future<AppUser> signIn({
    required String email,
    required String password,
  }) async {
    final user = await _dataSource.signIn(email: email, password: password);
    _cachedUser = user;
    return _cachedUser!;
  }

  @override
  Future<void> signOut() async {
    _cachedUser = null;
    await _dataSource.signOut();
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final user = await _dataSource.getCurrentUser();
    if (user == null) return null;
    _cachedUser = user;
    return _cachedUser;
  }
}
