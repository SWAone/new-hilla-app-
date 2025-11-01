import '../models/college_api.dart';
import 'api_client.dart';

class CollegesRepository {
  CollegesRepository({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  Future<PaginatedColleges> fetchColleges({
    int page = 1,
    int limit = 10,
    String? search,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'limit': limit,
      'sortBy': 'createdAt',
      'sortOrder': 'desc',
    };

    if (search != null && search.isNotEmpty) {
      query['search'] = search;
    }

    final response = await _api.get(
      '/api/v1/colleges',
      query: query,
    );

    return PaginatedColleges.fromApiResponse(response);
  }

  Future<CollegeApi> fetchCollegeById(String id) async {
    final response = await _api.get('/api/v1/colleges/$id');
    final data = response['data'] as Map<String, dynamic>;
    return CollegeApi.fromJson(data);
  }
}

