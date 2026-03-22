import 'dart:async';

import 'package:get/get.dart';

import '../../core/enums/acquisition_source.dart';
import '../../core/enums/client_status.dart';
import '../../core/enums/session_type.dart';
import '../../domain/entities/client_list_query.dart';

mixin ClientListQueryMixin on GetxController {
  final searchQuery = ''.obs;
  final query = const ClientListQuery().obs;
  final totalCount = 0.obs;

  Timer? _searchTimer;

  bool get hasActiveFilters =>
      query.value.tags.isNotEmpty ||
      query.value.acquisitionSource != null ||
      query.value.statusFilter != null ||
      query.value.sessionTypeFilter != null;

  /// Called whenever a server-side query parameter changes (triggers fetch).
  void onQueryChanged() {}

  /// Called whenever a local-only filter changes (no server fetch).
  void onLocalFilterChanged() {}

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

  void setStatusFilter(ClientStatus? status) {
    query.value = query.value.copyWith(statusFilter: status, page: 0);
    onLocalFilterChanged();
  }

  void setSessionTypeFilter(SessionType? sessionType) {
    query.value = query.value.copyWith(sessionTypeFilter: sessionType, page: 0);
    onLocalFilterChanged();
  }

  void clearFilters() {
    query.value = query.value.copyWith(
      tags: [],
      acquisitionSource: null,
      statusFilter: null,
      sessionTypeFilter: null,
      page: 0,
    );
    onQueryChanged();
  }
}
