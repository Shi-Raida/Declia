import 'package:json_annotation/json_annotation.dart';

enum CommunicationChannel {
  @JsonValue('email')
  email,
  @JsonValue('sms')
  sms,
}

extension CommunicationChannelJson on CommunicationChannel {
  String get jsonValue => switch (this) {
    CommunicationChannel.email => 'email',
    CommunicationChannel.sms => 'sms',
  };
}
