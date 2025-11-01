import '../models/slider_api.dart';
import 'api_client.dart';

class SlidersRepository {
  SlidersRepository({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  Future<List<SliderApi>> fetchActiveSliders() async {
    final response = await _api.get('/api/v1/sliders/active');
    final data = response['data'];
    
    if (data is List) {
      return data
          .map<SliderApi>((e) => SliderApi.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    
    return <SliderApi>[];
  }

  Future<List<SliderApi>> fetchSliders({
    int page = 1,
    int limit = 10,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'limit': limit,
    };

    final response = await _api.get(
      '/api/v1/sliders',
      query: query,
    );

    final data = response['data'];
    
    if (data is List) {
      return data
          .map<SliderApi>((e) => SliderApi.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    
    return <SliderApi>[];
  }

  Future<SliderApi> fetchSliderById(String id) async {
    final response = await _api.get('/api/v1/sliders/$id');
    final data = response['data'] as Map<String, dynamic>;
    return SliderApi.fromJson(data);
  }
}

