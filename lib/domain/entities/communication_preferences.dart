import 'package:freezed_annotation/freezed_annotation.dart';

part 'communication_preferences.freezed.dart';
part 'communication_preferences.g.dart';

@freezed
class CommunicationPreferences with _$CommunicationPreferences {
  const factory CommunicationPreferences({
    @Default(false) bool email,
    @Default(false) bool sms,
    @Default(false) bool phone,
  }) = _CommunicationPreferences;

  factory CommunicationPreferences.fromJson(Map<String, dynamic> json) =>
      _$CommunicationPreferencesFromJson(json);
}
