class Pages {
  int page;

  int perPage;
  int total;
  int pageCount = 0;

  Pages({this.page = 1, this.perPage = 15, this.total = 0, this.pageCount = 0});

  factory Pages.fromJson(Map<String, dynamic> json) => Pages(
        page: json['current'] as int,
        perPage: json['size'] as int,
        total: json['total'] as int,
        pageCount: json['pages'] as int,
      );

  @override
  String toString() {
    return 'Pages{page: $page, perPage: $perPage, total: $total, pageCount: $pageCount}';
  }
}
