import '../../core/enums/client_sort_field.dart';
import '../../core/enums/sort_direction.dart';
import 'client_list_query_mixin.dart';

mixin ClientPaginationMixin on ClientListQueryMixin {
  int get totalPages => totalCount.value == 0
      ? 1
      : (totalCount.value / query.value.pageSize).ceil();
  bool get hasNextPage => query.value.page < totalPages - 1;
  bool get hasPreviousPage => query.value.page > 0;

  void goToPage(int page) {
    if (page < 0 || page >= totalPages) return;
    query.value = query.value.copyWith(page: page);
    onQueryChanged();
  }

  void nextPage() => goToPage(query.value.page + 1);
  void previousPage() => goToPage(query.value.page - 1);

  void setSort(ClientSortField field, SortDirection direction) {
    query.value = query.value.copyWith(
      sortField: field,
      sortDirection: direction,
      page: 0,
    );
    onQueryChanged();
  }

  void toggleSort(ClientSortField field) {
    if (query.value.sortField == field) {
      final newDirection = query.value.sortDirection == SortDirection.ascending
          ? SortDirection.descending
          : SortDirection.ascending;
      setSort(field, newDirection);
    } else {
      setSort(field, SortDirection.ascending);
    }
  }
}
