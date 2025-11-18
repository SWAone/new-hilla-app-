import 'package:flutter/material.dart';

import '../shared/env.dart';

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
      imageUrl: _resolveImageUrl(json),
      buttonText: json['buttonText']?.toString(),
      buttonLink: json['buttonLink']?.toString(),
      order: json['order'] is int
          ? json['order'] as int
          : int.tryParse('${json['order'] ?? 0}'),
    );
  }

  static String? _resolveImageUrl(Map<String, dynamic> json) {
    final fullUrl = json['imageFullUrl']?.toString();
    final normalizedFull = _normalizeAbsoluteUrl(fullUrl);
    if (normalizedFull != null) {
      return normalizedFull;
    }

    final relativePath = json['imageUrl']?.toString();
    if (relativePath != null && relativePath.isNotEmpty) {
      return _buildUploadsUrl(relativePath);
    }

    final fallback = json['image']?.toString();
    if (fallback == null || fallback.isEmpty) return null;

    if (fallback.startsWith('http')) {
      return _normalizeAbsoluteUrl(fallback) ?? fallback;
    }

    return _buildUploadsUrl(fallback);
  }

  static String? _normalizeAbsoluteUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    final uri = Uri.tryParse(url);
    if (uri == null) return url;

    if (uri.host == 'localhost' ||
        uri.host == '127.0.0.1' ||
        uri.host == '::1') {
      final base = Uri.parse(Env.baseUrl);
      final normalized = Uri(
        scheme: base.scheme,
        host: base.host,
        port: base.hasPort ? base.port : null,
        path: uri.path,
      );
      return normalized.toString();
    }

    return url;
  }

  static String _buildUploadsUrl(String path) {
    final normalizedPath = path.startsWith('/') ? path.substring(1) : path;
    return '${Env.baseUrl}/uploads/$normalizedPath';
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

