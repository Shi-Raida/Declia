import 'package:freezed_annotation/freezed_annotation.dart';

part 'external_calendar_event.freezed.dart';
part 'external_calendar_event.g.dart';

@freezed
class ExternalCalendarEvent with _$ExternalCalendarEvent {
  @JsonSerializable(explicitToJson: true)
  const factory ExternalCalendarEvent({
    required String id,
    @JsonKey(name: 'tenant_id') required String tenantId,
    @JsonKey(name: 'google_event_id') required String googleEventId,
    required String title,
    String? location,
    @JsonKey(name: 'start_at') required DateTime startAt,
    @JsonKey(name: 'end_at') required DateTime endAt,
    @JsonKey(name: 'is_all_day') required bool isAllDay,
    required String status,
    @JsonKey(name: 'source') @Default('google') String source,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ExternalCalendarEvent;

  factory ExternalCalendarEvent.fromJson(Map<String, dynamic> json) =>
      _$ExternalCalendarEventFromJson(json);
}
