import '../models/event_api.dart';
import 'api_client.dart';

class EventsRepository {
  EventsRepository({ApiClient? apiClient}) : _api = apiClient ?? ApiClient();

  final ApiClient _api;

  Future<PaginatedEvents> fetchEvents({
    int page = 1,
    int limit = 10,
    String? type,
    String? status,
    String? search,
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'limit': limit,
      'sortBy': 'startDate',
      'sortOrder': 'asc',
    };

    if (type != null && type.isNotEmpty) {
      query['type'] = type;
    }

    if (status != null && status.isNotEmpty) {
      query['status'] = status;
    }

    if (search != null && search.isNotEmpty) {
      query['search'] = search;
    }

    final response = await _api.get(
      '/api/v1/events',
      query: query,
    );

    return PaginatedEvents.fromApiResponse(response);
  }

  Future<EventApi> fetchEventById(String id) async {
    final response = await _api.get('/api/v1/events/$id');
    final data = response['data'] as Map<String, dynamic>;
    return EventApi.fromJson(data);
  }
}

