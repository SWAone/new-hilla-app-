import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/base_controller.dart';
import '../../models/event_model.dart';
import '../../models/event_api.dart' as api;
import '../../data/events_repository.dart';
import '../../core/theme/app_colors.dart';

class EventsController extends BaseController {
  final RxList<Event> events = <Event>[].obs;
  final RxList<Event> filteredEvents = <Event>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isSearching = false.obs;
  final Rx<EventType?> selectedType = Rx<EventType?>(null);
  final Rx<EventStatus?> selectedStatus = Rx<EventStatus?>(null);
  final RxInt selectedTabIndex = 0.obs; // 0: All, 1: Upcoming, 2: Ongoing, 3: Completed

  final EventsRepository _repository = EventsRepository();

  @override
  void onInit() {
    super.onInit();
    loadEvents();
  }

  Future<void> loadEvents() async {
    try {
      setLoading(true);
      clearError();
      
      final paginatedEvents = await _repository.fetchEvents(
        page: 1,
        limit: 100, // جلب عدد كبير للحصول على جميع الفعاليات
      );
      
      events.assignAll(paginatedEvents.events.map(_convertToEvent).toList());
      filteredEvents.value = events;
      
    } catch (e) {
      debugPrint('Error fetching events: $e');
      setError('فشل في تحميل الفعاليات: ${e.toString()}');
      showErrorSnackBar('فشل في تحميل الفعاليات');
    } finally {
      setLoading(false);
    }
  }

  Event _convertToEvent(api.EventApi apiEvent) {
    return Event(
      id: apiEvent.id,
      title: apiEvent.title,
      description: apiEvent.description,
      startDate: apiEvent.startDate,
      endDate: apiEvent.endDate,
      location: apiEvent.location,
      organizer: apiEvent.organizer,
      speakers: apiEvent.speakers,
      type: _mapType(apiEvent.type),
      status: _mapStatus(apiEvent.status),
      categoryColor: _getColorForType(apiEvent.type),
      imageUrl: apiEvent.imageUrl ?? '',
      maxAttendees: apiEvent.maxAttendees,
      currentAttendees: apiEvent.currentAttendees,
      tags: apiEvent.tags,
      contactInfo: apiEvent.contactInfo,
      allowRegistration: apiEvent.allowRegistration,
      registrationDeadline: apiEvent.registrationDeadline,
    );
  }

  EventType _mapType(String type) {
    switch (type.toLowerCase()) {
      case 'conference':
        return EventType.conference;
      case 'workshop':
        return EventType.workshop;
      case 'seminar':
        return EventType.seminar;
      case 'cultural':
        return EventType.cultural;
      case 'sports':
        return EventType.sports;
      case 'academic':
        return EventType.academic;
      case 'graduation':
        return EventType.graduation;
      case 'ceremony':
        return EventType.ceremony;
      default:
        return EventType.academic;
    }
  }

  EventStatus _mapStatus(String status) {
    switch (status.toLowerCase()) {
      case 'upcoming':
        return EventStatus.upcoming;
      case 'ongoing':
        return EventStatus.ongoing;
      case 'completed':
        return EventStatus.completed;
      default:
        return EventStatus.upcoming;
    }
  }

  Color _getColorForType(String type) {
    switch (type.toLowerCase()) {
      case 'conference':
        return const Color(0xFF1976D2); // Blue
      case 'workshop':
        return const Color(0xFF2E7D32); // Green
      case 'seminar':
        return const Color(0xFF7B1FA2); // Purple
      case 'cultural':
        return const Color(0xFFD32F2F); // Red
      case 'sports':
        return const Color(0xFF4CAF50); // Light Green
      case 'academic':
        return const Color(0xFF2196F3); // Light Blue
      case 'graduation':
        return const Color(0xFF795548); // Brown
      case 'ceremony':
        return const Color(0xFFFF9800); // Orange
      default:
        return AppColors.accent;
    }
  }

  void searchEvents(String query) {
    searchQuery.value = query;
    isSearching.value = query.isNotEmpty;
    _applyFilters();
  }

  void filterByType(EventType? type) {
    selectedType.value = type;
    _applyFilters();
  }

  void filterByStatus(EventStatus? status) {
    selectedStatus.value = status;
    _applyFilters();
  }

  void setTabIndex(int index) {
    selectedTabIndex.value = index;
    _applyFilters();
  }

  void _applyFilters() {
    List<Event> filtered = events;

    // Filter by tab
    switch (selectedTabIndex.value) {
      case 1:
        filtered = filtered.where((event) => event.isUpcoming).toList();
        break;
      case 2:
        filtered = filtered.where((event) => event.isOngoing).toList();
        break;
      case 3:
        filtered = filtered.where((event) => event.isCompleted).toList();
        break;
      default:
        // All events
        break;
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((event) =>
          event.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          event.description.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          event.tags.any((tag) => tag.toLowerCase().contains(searchQuery.value.toLowerCase())))
          .toList();
    }

    // Filter by type
    if (selectedType.value != null) {
      filtered = filtered.where((event) => event.type == selectedType.value).toList();
    }

    // Filter by status (if not already filtered by tab)
    if (selectedStatus.value != null && selectedTabIndex.value == 0) {
      filtered = filtered.where((event) => event.status == selectedStatus.value).toList();
    }

    filteredEvents.value = filtered;
  }

  void clearSearch() {
    searchQuery.value = '';
    isSearching.value = false;
    selectedType.value = null;
    selectedStatus.value = null;
    selectedTabIndex.value = 0;
    filteredEvents.value = events;
  }

  Event? getEventById(String id) {
    try {
      return events.firstWhere((event) => event.id == id);
    } catch (e) {
      return null;
    }
  }

  List<Event> getUpcomingEvents() {
    return events.where((event) => event.isUpcoming).toList();
  }

  List<Event> getOngoingEvents() {
    return events.where((event) => event.isOngoing).toList();
  }

  List<Event> getCompletedEvents() {
    return events.where((event) => event.isCompleted).toList();
  }

  List<Event> getEventsByType(EventType type) {
    return events.where((event) => event.type == type).toList();
  }

  String getTabTitle(int index) {
    switch (index) {
      case 0:
        return 'الكل';
      case 1:
        return 'قادمة';
      case 2:
        return 'جارية';
      case 3:
        return 'منتهية';
      default:
        return '';
    }
  }
}

