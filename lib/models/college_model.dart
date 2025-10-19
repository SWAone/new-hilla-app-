import 'package:flutter/material.dart';

class College {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final List<Department> departments;
  final Color primaryColor;
  final Color secondaryColor;
  final String imageUrl;
  final AdmissionGuide admissionGuide;
  final List<FacultyMember> facultyMembers;

  College({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.departments,
    required this.primaryColor,
    required this.secondaryColor,
    required this.imageUrl,
    required this.admissionGuide,
    required this.facultyMembers,
  });
}

class AdmissionGuide {
  final double requiredGPA;
  final List<String> requirements;
  final List<AdmissionDocument> documents;
  final String additionalInfo;

  AdmissionGuide({
    required this.requiredGPA,
    required this.requirements,
    required this.documents,
    required this.additionalInfo,
  });
}

class AdmissionDocument {
  final String name;
  final String type; // 'pdf' or 'word'
  final String downloadUrl;
  final String description;

  AdmissionDocument({
    required this.name,
    required this.type,
    required this.downloadUrl,
    required this.description,
  });
}

class Department {
  final String id;
  final String name;
  final String description;
  final int studentCount;
  final String degree;
  final List<String> subjects;

  Department({
    required this.id,
    required this.name,
    required this.description,
    required this.studentCount,
    required this.degree,
    required this.subjects,
  });
}

class FacultyMember {
  final String id;
  final String name;
  final String title;
  final String specialization;
  final String bio;
  final String imageUrl;
  final String email;
  final List<String> qualifications;
  final int experienceYears;
  final List<String> researchAreas;

  FacultyMember({
    required this.id,
    required this.name,
    required this.title,
    required this.specialization,
    required this.bio,
    required this.imageUrl,
    required this.email,
    required this.qualifications,
    required this.experienceYears,
    required this.researchAreas,
  });
}

