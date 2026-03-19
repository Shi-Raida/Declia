import 'package:json_annotation/json_annotation.dart';

enum SessionStatus {
  @JsonValue('scheduled')
  scheduled,
  @JsonValue('confirmed')
  confirmed,
  @JsonValue('completed')
  completed,
  @JsonValue('cancelled')
  cancelled,
  @JsonValue('no_show')
  noShow,
}

extension SessionStatusJson on SessionStatus {
  String get jsonValue => switch (this) {
    SessionStatus.scheduled => 'scheduled',
    SessionStatus.confirmed => 'confirmed',
    SessionStatus.completed => 'completed',
    SessionStatus.cancelled => 'cancelled',
    SessionStatus.noShow => 'no_show',
  };
}
