import 'package:freezed_annotation/freezed_annotation.dart';

part 'tenant.freezed.dart';
part 'tenant.g.dart';

@freezed
class TenantBranding with _$TenantBranding {
  const factory TenantBranding({
    @JsonKey(name: 'primary_color') String? primaryColor,
    @JsonKey(name: 'logo_url') String? logoUrl,
  }) = _TenantBranding;

  factory TenantBranding.fromJson(Map<String, dynamic> json) =>
      _$TenantBrandingFromJson(json);
}

@freezed
class Tenant with _$Tenant {
  const factory Tenant({
    required String id,
    required String name,
    required String slug,
    required TenantBranding branding,
    String? domain,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _Tenant;

  factory Tenant.fromJson(Map<String, dynamic> json) => _$TenantFromJson(json);
}
