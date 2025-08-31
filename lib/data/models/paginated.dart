class Paginated<T> {
  final List<T> items;
  final int page;
  final int pageSize;
  final int total;

  Paginated({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
  });

  static Paginated<R> fromJson<R>(
    Map<String, dynamic> json,
    R Function(Map<String, dynamic>) fromItem,
  ) {
    final list = (json['items'] as List? ?? [])
        .cast<Map<String, dynamic>>()
        .map(fromItem)
        .toList();

    return Paginated<R>(
      items: list,
      page: json['page'] as int? ?? 1,
      pageSize: json['page_size'] as int? ?? list.length,
      total: json['total'] as int? ?? list.length,
    );
  }
}
