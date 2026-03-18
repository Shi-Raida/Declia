import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
class Address with _$Address {
  const factory Address({
    String? street,
    @JsonKey(name: 'street2') String? street2,
    String? city,
    @JsonKey(name: 'postal_code') String? postalCode,
    String? country,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}
