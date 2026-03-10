import 'package:get/get.dart';

import '../../domain/entities/app_user.dart';
import '../../usecases/usecase.dart';

class AuthStateController extends GetxController {
  AuthStateController(this._signOut);

  final UseCase<void, NoParams> _signOut;
  final currentUser = Rxn<AppUser>();

  bool get isAuthenticated => currentUser.value != null;

  void setUser(AppUser? user) => currentUser.value = user;

  Future<void> signOut() async {
    currentUser.value = null;
    await _signOut(const NoParams());
  }
}
