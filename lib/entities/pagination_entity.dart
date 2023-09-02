/// Paginated data
class PaginationEntity<T> {
  /// Number of elements already fetched
  final int count;

  /// Number of elements available
  final int total;

  /// Last and current page fetched
  final int currentPageNumber;

  /// Number of available pages to fetch
  final int totalPage;

  /// Number of element fetched on this page
  final int pageSize;

  /// Another page is available
  final bool hasMore;

  /// The fetched data
  final Iterable<T> data;

  const PaginationEntity({
    required this.count,
    required this.total,
    required this.totalPage,
    required this.pageSize,
    required this.currentPageNumber,
    required this.hasMore,
    required this.data,
  });
}
