import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/enums/acquisition_source.dart';
import '../../core/enums/client_sort_field.dart';
import '../../core/enums/sort_direction.dart';

part 'client_list_query.freezed.dart';

@freezed
class ClientListQuery with _$ClientListQuery {
  const factory ClientListQuery({
    @Default('') String search,
    @Default([]) List<String> tags,
    AcquisitionSource? acquisitionSource,
    @Default(ClientSortField.name) ClientSortField sortField,
    @Default(SortDirection.ascending) SortDirection sortDirection,
    @Default(0) int page,
    @Default(25) int pageSize,
  }) = _ClientListQuery;
}
