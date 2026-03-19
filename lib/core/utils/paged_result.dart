class PagedResult<T> {
  const PagedResult({required this.items, required this.totalCount});
  final List<T> items;
  final int totalCount;
}
