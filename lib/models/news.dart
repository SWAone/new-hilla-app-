class News {
  const News({
    required this.id,
    required this.title,
    this.summary,
    this.thumbnailUrl,
    this.publishDate,
    this.views,
    this.category,
  });

  final String id;
  final String title;
  final String? summary;
  final String? thumbnailUrl;
  final DateTime? publishDate;
  final int? views;
  final String? category;

  static News fromJson(Map<String, dynamic> json) {
    return News(
      id: (json['_id'] ?? json['id']).toString(),
      title: (json['title'] ?? '').toString(),
      summary: json['summary']?.toString(),
      thumbnailUrl: json['thumbnail']?.toString() ?? json['image']?.toString(),
      publishDate: json['publishDate'] != null ? DateTime.tryParse(json['publishDate'].toString()) : null,
      views: json['views'] is int ? json['views'] as int : int.tryParse('${json['views'] ?? ''}'),
      category: json['category']?.toString(),
    );
  }
}

class PaginatedNews {
  const PaginatedNews({required this.items, required this.page, required this.limit, required this.total, required this.totalPages});

  final List<News> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  static PaginatedNews fromApiResponse(Map<String, dynamic> json) {
    final data = json['data'];
    final meta = json['meta'] ?? const {};
    final items = data is List ? data.map<News>((e) => News.fromJson(e as Map<String, dynamic>)).toList() : <News>[];
    return PaginatedNews(
      items: items,
      page: meta['page'] is int ? meta['page'] as int : int.tryParse('${meta['page'] ?? 1}') ?? 1,
      limit: meta['limit'] is int ? meta['limit'] as int : int.tryParse('${meta['limit'] ?? 10}') ?? 10,
      total: meta['total'] is int ? meta['total'] as int : int.tryParse('${meta['total'] ?? items.length}') ?? items.length,
      totalPages: meta['totalPages'] is int ? meta['totalPages'] as int : int.tryParse('${meta['totalPages'] ?? 1}') ?? 1,
    );
  }
}


