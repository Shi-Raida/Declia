import 'package:freezed_annotation/freezed_annotation.dart';

part 'google_calendar_connection.freezed.dart';
part 'google_calendar_connection.g.dart';

@freezed
class GoogleCalendarConnection with _$GoogleCalendarConnection {
  @JsonSerializable(explicitToJson: true)
  const factory GoogleCalendarConnection({
    required String id,
    @JsonKey(name: 'tenant_id') required String tenantId,
    @JsonKey(name: 'calendar_id') required String calendarId,
    @JsonKey(name: 'sync_enabled') required bool syncEnabled,
    @JsonKey(name: 'last_sync_at') DateTime? lastSyncAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _GoogleCalendarConnection;

  factory GoogleCalendarConnection.fromJson(Map<String, dynamic> json) =>
      _$GoogleCalendarConnectionFromJson(json);
}
