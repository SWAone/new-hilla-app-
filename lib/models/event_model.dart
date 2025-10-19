import 'package:flutter/material.dart';

class Event {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String location;
  final String organizer;
  final List<String> speakers;
  final EventType type;
  final EventStatus status;
  final Color categoryColor;
  final String imageUrl;
  final int maxAttendees;
  final int currentAttendees;
  final List<String> tags;
  final String contactInfo;
  final bool allowRegistration;
  final DateTime? registrationDeadline;

  Event({
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
    required this.categoryColor,
    required this.imageUrl,
    this.maxAttendees = 0,
    this.currentAttendees = 0,
    required this.tags,
    required this.contactInfo,
    this.allowRegistration = false,
    this.registrationDeadline,
  });

  bool get isUpcoming => status == EventStatus.upcoming;
  bool get isOngoing => status == EventStatus.ongoing;
  bool get isCompleted => status == EventStatus.completed;
  
  bool get canRegister {
    if (!allowRegistration) return false;
    if (status != EventStatus.upcoming) return false;
    if (registrationDeadline != null && DateTime.now().isAfter(registrationDeadline!)) return false;
    if (maxAttendees > 0 && currentAttendees >= maxAttendees) return false;
    return true;
  }
  
  bool get isRegistrationOpen {
    if (!allowRegistration) return false;
    if (registrationDeadline == null) return true;
    return DateTime.now().isBefore(registrationDeadline!);
  }

  String get dateRange {
    if (startDate.day == endDate.day && startDate.month == endDate.month && startDate.year == endDate.year) {
      return '${startDate.day}/${startDate.month}/${startDate.year}';
    } else {
      return '${startDate.day}/${startDate.month}/${startDate.year} - ${endDate.day}/${endDate.month}/${endDate.year}';
    }
  }

  String get timeRange {
    return '${startDate.hour.toString().padLeft(2, '0')}:${startDate.minute.toString().padLeft(2, '0')} - ${endDate.hour.toString().padLeft(2, '0')}:${endDate.minute.toString().padLeft(2, '0')}';
  }
}

enum EventType {
  conference,
  workshop,
  seminar,
  cultural,
  sports,
  academic,
  graduation,
  ceremony,
}

enum EventStatus {
  upcoming,
  ongoing,
  completed,
}

extension EventTypeExtension on EventType {
  String get displayName {
    switch (this) {
      case EventType.conference:
        return 'مؤتمر';
      case EventType.workshop:
        return 'ورشة عمل';
      case EventType.seminar:
        return 'ندوة';
      case EventType.cultural:
        return 'ثقافي';
      case EventType.sports:
        return 'رياضي';
      case EventType.academic:
        return 'أكاديمي';
      case EventType.graduation:
        return 'تخرج';
      case EventType.ceremony:
        return 'حفل';
    }
  }
}

extension EventStatusExtension on EventStatus {
  String get displayName {
    switch (this) {
      case EventStatus.upcoming:
        return 'قادم';
      case EventStatus.ongoing:
        return 'جاري';
      case EventStatus.completed:
        return 'منتهي';
    }
  }
}

