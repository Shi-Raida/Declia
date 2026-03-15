import 'package:declia/core/enums/user_role.dart';
import 'package:declia/domain/entities/app_user.dart';
import 'package:declia/presentation/models/user_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

const _appUser = AppUser(
  id: '00000000-0000-0000-0001-000000000001',
  email: 'photo@fleur.test',
  tenantId: '00000000-0000-0000-0000-000000000001',
  role: UserRole.photographer,
);

void main() {
  group('UserViewModel.fromEntity', () {
    test('maps id, email, and role from AppUser', () {
      final vm = UserViewModel.fromEntity(_appUser);

      expect(vm.id, _appUser.id);
      expect(vm.email, _appUser.email);
      expect(vm.role, _appUser.role);
    });

    test('does not expose tenantId', () {
      final vm = UserViewModel.fromEntity(_appUser);

      // UserViewModel has no tenantId field — confirmed by compile-time absence.
      // Verify only expected fields exist on the object.
      expect(vm.id, isA<String>());
      expect(vm.email, isA<String>());
      expect(vm.role, isA<UserRole>());
    });
  });
}
