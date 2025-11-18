import 'package:flutter/foundation.dart';
import '../models/news.dart';
import 'api_client.dart';

class NewsRepository {
  NewsRepository({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  Future<PaginatedNews> fetchNews({
    int page = 1,
    int limit = 10,
    String? search,
    String? category,
    bool? isPublished,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'limit': limit,
      'sortBy': 'publishDate',
      'sortOrder': 'desc',
    };

    if (search != null && search.isNotEmpty) {
      query['search'] = search;
    }

    if (category != null && category.isNotEmpty) {
      query['category'] = category;
    }

    // لا نرسل isPublished=true لأن السيرفر يقوم بتطبيقه تلقائيًا للمستخدمين العاديين
    // نرسل isPublished فقط إذا كانت القيمة false (للعرض في وضع الأدمن)
    if (isPublished != null && isPublished == false) {
      query['isPublished'] = 'false';
    }

    if (kDebugMode) {
      debugPrint('Fetching news with query: $query');
    }

    final response = await _api.get(
      '/api/v1/news',
      query: query,
    );

    if (kDebugMode) {
      debugPrint('News API response: ${response['data']?.length ?? 0} items');
    }

    return PaginatedNews.fromApiResponse(response);
  }
}


