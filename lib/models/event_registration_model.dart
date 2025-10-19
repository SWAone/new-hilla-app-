import 'package:flutter/material.dart';

class EventRegistration {
  final String id;
  final String eventId;
  final String fullName;
  final String email;
  final String phoneNumber;
  final String studentId;
  final String college;
  final String department;
  final DateTime registrationDate;
  final RegistrationStatus status;
  final String? notes;

  EventRegistration({
    required this.id,
    required this.eventId,
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.studentId,
    required this.college,
    required this.department,
    required this.registrationDate,
    required this.status,
    this.notes,
  });
}

enum RegistrationStatus {
  pending,
  confirmed,
  cancelled,
}

extension RegistrationStatusExtension on RegistrationStatus {
  String get displayName {
    switch (this) {
      case RegistrationStatus.pending:
        return 'في الانتظار';
      case RegistrationStatus.confirmed:
        return 'مؤكد';
      case RegistrationStatus.cancelled:
        return 'ملغي';
    }
  }

  Color get color {
    switch (this) {
      case RegistrationStatus.pending:
        return Colors.orange;
      case RegistrationStatus.confirmed:
        return Colors.green;
      case RegistrationStatus.cancelled:
        return Colors.red;
    }
  }
}
