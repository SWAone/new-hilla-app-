class EventApi {
  const EventApi({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.location,
    required this.organizer,
    required this.speakers,
    required this.type,
    required this.status,
    this.imageUrl,
    this.maxAttendees = 0,
    this.currentAttendees = 0,
    required this.tags,
    required this.contactInfo,
    this.allowRegistration = false,
    this.registrationDeadline,
  });

  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String organizer;
  final List<String> speakers;
  final String type;
  final String status;
  final String? imageUrl;
  final int maxAttendees;
  final int currentAttendees;
  final List<String> tags;
  final String contactInfo;
  final bool allowRegistration;
  final DateTime? registrationDeadline;

  static EventApi fromJson(Map<String, dynamic> json) {
    return EventApi(
      id: (json['_id'] ?? json['id']).toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      startDate: json['startDate'] != null
          ? DateTime.tryParse(json['startDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
      endDate: json['endDate'] != null
          ? DateTime.tryParse(json['endDate'].toString()) ?? DateTime.now()
          : DateTime.now(),
      location: (json['location'] ?? '').toString(),
      organizer: (json['organizer'] ?? '').toString(),
      speakers: json['speakers'] is List
          ? (json['speakers'] as List).map((e) => e.toString()).toList()
          : <String>[],
      type: (json['type'] ?? 'academic').toString(),
      status: (json['status'] ?? 'upcoming').toString(),
      imageUrl: json['imageUrl']?.toString(),
      maxAttendees: json['maxAttendees'] is int
          ? json['maxAttendees'] as int
          : int.tryParse('${json['maxAttendees'] ?? 0}') ?? 0,
      currentAttendees: json['currentAttendees'] is int
          ? json['currentAttendees'] as int
          : int.tryParse('${json['currentAttendees'] ?? 0}') ?? 0,
      tags: json['tags'] is List
          ? (json['tags'] as List).map((e) => e.toString()).toList()
          : <String>[],
      contactInfo: (json['contactInfo'] ?? '').toString(),
      allowRegistration: json['allowRegistration'] == true,
      registrationDeadline: json['registrationDeadline'] != null
          ? DateTime.tryParse(json['registrationDeadline'].toString())
          : null,
    );
  }
}

class PaginatedEvents {
  const PaginatedEvents({
    required this.events,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
  });

  final List<EventApi> events;
  final int page;
  final int limit;
  final int total;
  final int totalPages;

  static PaginatedEvents fromApiResponse(Map<String, dynamic> json) {
    final data = json['data'];
    final meta = json['meta'] ?? const {};
    final pagination = meta['pagination'] ?? const {};
    
    final events = data is List
        ? data.map<EventApi>((e) => EventApi.fromJson(e as Map<String, dynamic>)).toList()
        : <EventApi>[];

    return PaginatedEvents(
      events: events,
      page: pagination['currentPage'] is int
          ? pagination['currentPage'] as int
          : int.tryParse('${pagination['currentPage'] ?? 1}') ?? 1,
      limit: pagination['itemsPerPage'] is int
          ? pagination['itemsPerPage'] as int
          : int.tryParse('${pagination['itemsPerPage'] ?? 10}') ?? 10,
      total: pagination['totalItems'] is int
          ? pagination['totalItems'] as int
          : int.tryParse('${pagination['totalItems'] ?? events.length}') ?? events.length,
      totalPages: pagination['totalPages'] is int
          ? pagination['totalPages'] as int
          : int.tryParse('${pagination['totalPages'] ?? 1}') ?? 1,
    );
  }
}

