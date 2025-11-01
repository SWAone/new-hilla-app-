import 'package:flutter/material.dart';

class SliderApi {
  const SliderApi({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
    this.imageUrl,
    this.buttonText,
    this.buttonLink,
    this.order,
  });

  final String id;
  final String title;
  final String description;
  final String icon; // اسم الأيقونة (سنتحولها إلى IconData)
  final String primaryColor;
  final String secondaryColor;
  final String? imageUrl;
  final String? buttonText;
  final String? buttonLink;
  final int? order;

  static SliderApi fromJson(Map<String, dynamic> json) {
    return SliderApi(
      id: (json['_id'] ?? json['id']).toString(),
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      icon: (json['icon'] ?? 'school').toString(),
      primaryColor: (json['primaryColor'] ?? '#1976D2').toString(),
      secondaryColor: (json['secondaryColor'] ?? '#42A5F5').toString(),
      imageUrl: json['imageUrl']?.toString(),
      buttonText: json['buttonText']?.toString(),
      buttonLink: json['buttonLink']?.toString(),
      order: json['order'] is int
          ? json['order'] as int
          : int.tryParse('${json['order'] ?? 0}'),
    );
  }
}

// Helper class to convert icon string to IconData
class IconHelper {
  static IconData getIconData(String iconName) {
    switch (iconName.toLowerCase()) {
      case 'school':
      case 'school_rounded':
        return Icons.school_rounded;
      case 'computer':
      case 'computer_rounded':
        return Icons.computer_rounded;
      case 'science':
      case 'science_rounded':
        return Icons.science_rounded;
      case 'medical_services':
        return Icons.medical_services_rounded;
      case 'engineering':
        return Icons.engineering_rounded;
      case 'business':
        return Icons.business_rounded;
      case 'palette':
        return Icons.palette_rounded;
      case 'event':
      case 'event_rounded':
        return Icons.event_rounded;
      case 'library':
      case 'library_books':
        return Icons.library_books_rounded;
      case 'sports':
      case 'sports_soccer':
        return Icons.sports_soccer_rounded;
      default:
        return Icons.school_rounded;
    }
  }
}

