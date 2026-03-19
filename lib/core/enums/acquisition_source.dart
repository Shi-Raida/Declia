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

extension AcquisitionSourceJson on AcquisitionSource {
  String get jsonValue => switch (this) {
    AcquisitionSource.referral => 'referral',
    AcquisitionSource.socialMedia => 'social_media',
    AcquisitionSource.website => 'website',
    AcquisitionSource.wordOfMouth => 'word_of_mouth',
    AcquisitionSource.event => 'event',
    AcquisitionSource.other => 'other',
  };
}
