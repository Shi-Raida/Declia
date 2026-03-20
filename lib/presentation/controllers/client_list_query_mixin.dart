import 'dart:async';

import 'package:get/get.dart';

import '../../core/enums/acquisition_source.dart';
import '../../core/enums/client_sort_field.dart';
import '../../core/enums/sort_direction.dart';
import '../../domain/entities/client_list_query.dart';

mixin ClientListQueryMixin on GetxController {
  final searchQuery = ''.obs;
  final query = const ClientListQuery().obs;
  final totalCount = 0.obs;

  Timer? _searchTimer;

  int get totalPages => totalCount.value == 0
      ? 1
      : (totalCount.value / query.value.pageSize).ceil();
  bool get hasNextPage => query.value.page < totalPages - 1;
  bool get hasPreviousPage => query.value.page > 0;
  bool get hasActiveFilters =>
      query.value.tags.isNotEmpty || query.value.acquisitionSource != null;

  /// Called whenever a query parameter changes. No-op by default; override
  /// in the controller to trigger a data reload.
  void onQueryChanged() {}

  @override
  void onInit() {
    super.onInit();
    ever(searchQuery, (q) {
      _searchTimer?.cancel();
      _searchTimer = Timer(const Duration(milliseconds: 300), () {
        query.value = query.value.copyWith(search: q.trim(), page: 0);
        onQueryChanged();
      });
    });
  }

  @override
  void onClose() {
    _searchTimer?.cancel();
    super.onClose();
  }

  void setTagFilter(List<String> tags) {
    query.value = query.value.copyWith(tags: tags, page: 0);
    onQueryChanged();
  }

  void addTag(String tag) {
    if (!query.value.tags.contains(tag)) {
      setTagFilter([...query.value.tags, tag]);
    }
  }

  void removeTag(String tag) {
    setTagFilter(query.value.tags.where((t) => t != tag).toList());
  }

  void setAcquisitionSourceFilter(AcquisitionSource? source) {
    query.value = query.value.copyWith(acquisitionSource: source, page: 0);
    onQueryChanged();
  }

  void clearFilters() {
    query.value = query.value.copyWith(
      tags: [],
      acquisitionSource: null,
      page: 0,
    );
    onQueryChanged();
  }

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

  void goToPage(int page) {
    if (page < 0 || page >= totalPages) return;
    query.value = query.value.copyWith(page: page);
    onQueryChanged();
  }

  void nextPage() => goToPage(query.value.page + 1);
  void previousPage() => goToPage(query.value.page - 1);
}
