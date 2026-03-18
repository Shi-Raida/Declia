import 'package:json_annotation/json_annotation.dart';

enum AcquisitionSource {
  @JsonValue('referral')
  referral,
  @JsonValue('social_media')
  socialMedia,
  @JsonValue('website')
  website,
  @JsonValue('word_of_mouth')
  wordOfMouth,
  @JsonValue('event')
  event,
  @JsonValue('other')
  other,
}
