import '../360_views/models/tour_scene.dart';
import 'api_client.dart';

class TourRepository {
  TourRepository({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  Future<List<TourScene>> fetchActiveTourScenes() async {
    final response = await _api.get('/api/v1/tours/active');
    final data = response['data'];
    
    if (data is List) {
      return data
          .map<TourScene>((e) => TourScene.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    
    return <TourScene>[];
  }

  Future<List<TourScene>> fetchTourScenes({
    int page = 1,
    int limit = 20,
    bool? isActive,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'limit': limit,
    };
    if (isActive != null) {
      query['isActive'] = isActive;
    }

    final response = await _api.get(
      '/api/v1/tours',
      query: query,
    );

    final data = response['data'];
    
    if (data is List) {
      return data
          .map<TourScene>((e) => TourScene.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    
    return <TourScene>[];
  }

  Future<TourScene> fetchTourSceneById(String id) async {
    final response = await _api.get('/api/v1/tours/$id');
    final data = response['data'] as Map<String, dynamic>;
    return TourScene.fromJson(data);
  }
}

