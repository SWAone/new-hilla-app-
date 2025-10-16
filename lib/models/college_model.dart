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

  College({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.departments,
    required this.primaryColor,
    required this.secondaryColor,
    required this.imageUrl,
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

