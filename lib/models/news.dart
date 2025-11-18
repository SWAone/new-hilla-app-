import 'package:flutter/foundation.dart';
import '../shared/env.dart';

class News {
  const News({
    required this.id,
    required this.title,
    this.summary,
    this.content,
    this.thumbnailUrl,
    this.publishDate,
    this.views,
    this.category,
  });

  final String id;
  final String title;
  final String? summary;
  final String? content;
  final String? thumbnailUrl;
  final DateTime? publishDate;
  final int? views;
  final String? category;

  static News fromJson(Map<String, dynamic> json) {
    String? imageUrl;
    
    // معالجة imageFullUrl - نتحقق إذا كان يحتوي على localhost
    if (json['imageFullUrl'] != null) {
      final fullUrl = json['imageFullUrl'].toString();
      // إذا كان يحتوي على localhost، نتجاهله ونبني الرابط من imageUrl
      if (fullUrl.contains('localhost')) {
        // نتجاهل imageFullUrl ونستخدم imageUrl لبناء الرابط بشكل صحيح
        final relativePath = json['imageUrl']?.toString() ?? '';
        if (relativePath.isNotEmpty && !relativePath.startsWith('http')) {
          imageUrl = '${Env.baseUrl}/uploads/$relativePath';
        } else if (relativePath.isNotEmpty) {
          imageUrl = relativePath;
        }
      } else {
        // إذا كان imageFullUrl لا يحتوي على localhost، نستخدمه مباشرة
        imageUrl = fullUrl;
      }
    }
    
    // إذا لم نحصل على imageUrl بعد، نستخدم imageUrl مباشرة
    if (imageUrl == null || imageUrl.isEmpty) {
      if (json['imageUrl'] != null) {
        final relativePath = json['imageUrl'].toString();
        if (relativePath.isNotEmpty && !relativePath.startsWith('http')) {
          imageUrl = '${Env.baseUrl}/uploads/$relativePath';
        } else {
          imageUrl = relativePath;
        }
      } else if (json['thumbnail'] != null || json['image'] != null) {
        final thumbnailPath = json['thumbnail']?.toString() ?? json['image']?.toString();
        if (thumbnailPath != null && !thumbnailPath.startsWith('http')) {
          imageUrl = '${Env.baseUrl}/uploads/$thumbnailPath';
        } else {
          imageUrl = thumbnailPath;
        }
      }
    }
    
    if (kDebugMode && imageUrl != null) {
      debugPrint('News image URL: $imageUrl');
    }
    
    return News(
      id: (json['_id'] ?? json['id']).toString(),
      title: (json['title'] ?? '').toString(),
      summary: json['summary']?.toString(),
      content: json['content']?.toString(),
      thumbnailUrl: imageUrl,
      publishDate: json['publishDate'] != null ? DateTime.tryParse(json['publishDate'].toString()) : null,
      views: json['views'] is int ? json['views'] as int : int.tryParse('${json['views'] ?? ''}'),
      category: json['category']?.toString(),
    );
  }
}

class PaginatedNews {
  const PaginatedNews({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNextPage,
    required this.hasPrevPage,
  });

  final List<News> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNextPage;
  final bool hasPrevPage;

  static PaginatedNews fromApiResponse(Map<String, dynamic> json) {
    final data = json['data'];
    final meta = (json['meta'] ?? const {}) as Map<String, dynamic>;
    final pagination = (meta['pagination'] ?? const {}) as Map<String, dynamic>;
    final items = data is List ? data.map<News>((e) => News.fromJson(e as Map<String, dynamic>)).toList() : <News>[];
    final currentPage = pagination['currentPage'] is int
        ? pagination['currentPage'] as int
        : int.tryParse('${pagination['currentPage'] ?? 1}') ?? 1;
    final itemsPerPage = pagination['itemsPerPage'] is int
        ? pagination['itemsPerPage'] as int
        : int.tryParse('${pagination['itemsPerPage'] ?? 10}') ?? 10;
    final totalItems = pagination['totalItems'] is int
        ? pagination['totalItems'] as int
        : int.tryParse('${pagination['totalItems'] ?? items.length}') ?? items.length;
    final totalPages = pagination['totalPages'] is int
        ? pagination['totalPages'] as int
        : int.tryParse('${pagination['totalPages'] ?? 1}') ?? 1;
    final hasNextPage = pagination['hasNextPage'] is bool
        ? pagination['hasNextPage'] as bool
        : (currentPage < totalPages);
    final hasPrevPage = pagination['hasPrevPage'] is bool
        ? pagination['hasPrevPage'] as bool
        : (currentPage > 1);

    return PaginatedNews(
      items: items,
      page: currentPage,
      limit: itemsPerPage,
      total: totalItems,
      totalPages: totalPages,
      hasNextPage: hasNextPage,
      hasPrevPage: hasPrevPage,
    );
  }
}


