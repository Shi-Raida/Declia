import 'package:get/get.dart';

import '../../core/logger/app_logger.dart';
import '../../usecases/usecase.dart';
import '../models/user_view_model.dart';

final class AuthStateController extends GetxController {
  AuthStateController(this._signOut, {AppLogger? logger}) : _logger = logger;

  final UseCase<void, NoParams> _signOut;
  final AppLogger? _logger;
  final currentUser = Rxn<UserViewModel>();

  bool get isAuthenticated => currentUser.value != null;

  void setUser(UserViewModel? user) {
    _logger?.info('User set', metadata: {'userId': user?.id});
    currentUser.value = user;
  }

  Future<void> signOut() async {
    _logger?.info('User signed out');
    currentUser.value = null;
    final result = await _signOut(const NoParams());
    result.fold(
      ok: (_) {},
      err: (failure) => _logger?.warning('Sign out failed: ${failure.message}'),
    );
  }
}
