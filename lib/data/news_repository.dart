import '../models/news.dart';
import 'api_client.dart';

class NewsRepository {
  NewsRepository({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  Future<PaginatedNews> fetchNews({int page = 1, int limit = 10}) async {
    final response = await _api.get(
      '/api/v1/news',
      query: {
        'page': page,
        'limit': limit,
        'sortBy': 'publishDate',
        'sortOrder': 'desc',
      },
    );

    return PaginatedNews.fromApiResponse(response);
  }
}


