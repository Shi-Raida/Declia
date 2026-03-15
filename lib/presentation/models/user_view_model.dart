import '../../core/enums/user_role.dart';
import '../../domain/entities/app_user.dart';

class UserViewModel {
  const UserViewModel({
    required this.id,
    required this.email,
    required this.role,
  });

  factory UserViewModel.fromEntity(AppUser user) =>
      UserViewModel(id: user.id, email: user.email, role: user.role);

  final String id;
  final String email;
  final UserRole role;
}
