import 'package:get/get.dart';

import '../../core/logger/app_logger.dart';
import '../../domain/entities/app_user.dart';
import '../../usecases/usecase.dart';

final class AuthStateController extends GetxController {
  AuthStateController(this._signOut, {AppLogger? logger}) : _logger = logger;

  final UseCase<void, NoParams> _signOut;
  final AppLogger? _logger;
  final currentUser = Rxn<AppUser>();

  bool get isAuthenticated => currentUser.value != null;

  void setUser(AppUser? user) {
    _logger?.info('User set', metadata: {'userId': user?.id});
    currentUser.value = user;
  }

  Future<void> signOut() async {
    _logger?.info('User signed out');
    currentUser.value = null;
    await _signOut(const NoParams());
  }
}
