import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/enums/acquisition_source.dart';
import 'address.dart';
import 'communication_preferences.dart';

part 'client.freezed.dart';
part 'client.g.dart';

@freezed
class Client with _$Client {
  @JsonSerializable(explicitToJson: true)
  const factory Client({
    required String id,
    @JsonKey(name: 'tenant_id') required String tenantId,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    String? email,
    String? phone,
    @JsonKey(name: 'date_of_birth') DateTime? dateOfBirth,
    Address? address,
    @JsonKey(name: 'acquisition_source') AcquisitionSource? acquisitionSource,
    @Default([]) List<String> tags,
    String? notes,
    Map<String, dynamic>? preferences,
    @JsonKey(name: 'communication_prefs')
    CommunicationPreferences? communicationPrefs,
    @JsonKey(name: 'gdpr_consent_date') DateTime? gdprConsentDate,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Client;

  factory Client.fromJson(Map<String, dynamic> json) =>
      _$ClientFromJson(json);
}
