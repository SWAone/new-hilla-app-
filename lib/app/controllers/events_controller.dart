import 'package:get/get.dart';
import '../../core/controllers/base_controller.dart';
import '../../models/event_model.dart';
import '../../data/events_data.dart';

class EventsController extends BaseController {
  final RxList<Event> events = <Event>[].obs;
  final RxList<Event> filteredEvents = <Event>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isSearching = false.obs;
  final Rx<EventType?> selectedType = Rx<EventType?>(null);
  final Rx<EventStatus?> selectedStatus = Rx<EventStatus?>(null);
  final RxInt selectedTabIndex = 0.obs; // 0: All, 1: Upcoming, 2: Ongoing, 3: Completed

  @override
  void onInit() {
    super.onInit();
    loadEvents();
  }

  Future<void> loadEvents() async {
    try {
      setLoading(true);
      clearError();
      
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 1000));
      
      events.value = EventsData.getEvents();
      filteredEvents.value = events;
      
    } catch (e) {
      setError('فشل في تحميل الفعاليات: ${e.toString()}');
      showErrorSnackBar('فشل في تحميل الفعاليات');
    } finally {
      setLoading(false);
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

