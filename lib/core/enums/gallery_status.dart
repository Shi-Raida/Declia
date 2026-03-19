import 'package:json_annotation/json_annotation.dart';

enum GalleryStatus {
  @JsonValue('draft')
  draft,
  @JsonValue('published')
  published,
  @JsonValue('archived')
  archived,
  @JsonValue('expired')
  expired,
}

extension GalleryStatusJson on GalleryStatus {
  String get jsonValue => switch (this) {
    GalleryStatus.draft => 'draft',
    GalleryStatus.published => 'published',
    GalleryStatus.archived => 'archived',
    GalleryStatus.expired => 'expired',
  };
}
