import 'package:get/get.dart';

mixin ClientSelectionMixin on GetxController {
  final selectedIds = <String>{}.obs;

  /// IDs checked by [isAllSelected] — override in subclass.
  List<String> get allItemIds;

  /// IDs selected by [toggleSelectAll] — override in subclass.
  List<String> get visibleItemIds;

  bool get isAllSelected =>
      allItemIds.isNotEmpty && allItemIds.every(selectedIds.contains);

  void toggleSelect(String id) {
    if (selectedIds.contains(id)) {
      selectedIds.remove(id);
    } else {
      selectedIds.add(id);
    }
  }

  void toggleSelectAll() {
    if (isAllSelected) {
      selectedIds.clear();
    } else {
      selectedIds.assignAll(visibleItemIds);
    }
  }

  void clearSelection() => selectedIds.clear();
  void deselectId(String id) => selectedIds.remove(id);
}
