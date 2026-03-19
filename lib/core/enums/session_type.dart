import 'package:json_annotation/json_annotation.dart';

enum SessionType {
  @JsonValue('family')
  family,
  @JsonValue('equestrian')
  equestrian,
  @JsonValue('event')
  event,
  @JsonValue('maternity')
  maternity,
  @JsonValue('school')
  school,
  @JsonValue('portrait')
  portrait,
  @JsonValue('mini_session')
  miniSession,
  @JsonValue('other')
  other,
}

extension SessionTypeJson on SessionType {
  String get jsonValue => switch (this) {
    SessionType.family => 'family',
    SessionType.equestrian => 'equestrian',
    SessionType.event => 'event',
    SessionType.maternity => 'maternity',
    SessionType.school => 'school',
    SessionType.portrait => 'portrait',
    SessionType.miniSession => 'mini_session',
    SessionType.other => 'other',
  };
}
