import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/enums/user_role.dart';

part 'app_user.freezed.dart';
part 'app_user.g.dart';

@freezed
class AppUser with _$AppUser {
  const factory AppUser({
    required String id,
    required String email,
    @JsonKey(name: 'tenant_id') required String tenantId,
    required UserRole role,
  }) = _AppUser;

  factory AppUser.fromJson(Map<String, dynamic> json) =>
      _$AppUserFromJson(json);
}
