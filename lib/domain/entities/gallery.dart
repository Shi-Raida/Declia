import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/enums/gallery_status.dart';

part 'gallery.freezed.dart';
part 'gallery.g.dart';

@freezed
class Gallery with _$Gallery {
  @JsonSerializable(explicitToJson: true)
  const factory Gallery({
    required String id,
    @JsonKey(name: 'tenant_id') required String tenantId,
    @JsonKey(name: 'client_id') required String clientId,
    @JsonKey(name: 'session_id') String? sessionId,
    required String title,
    required GalleryStatus status,
    @JsonKey(name: 'url_slug') String? urlSlug,
    @JsonKey(name: 'photo_count') required int photoCount,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Gallery;

  factory Gallery.fromJson(Map<String, dynamic> json) =>
      _$GalleryFromJson(json);
}
