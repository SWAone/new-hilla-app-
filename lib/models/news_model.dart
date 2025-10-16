import 'package:flutter/material.dart';

class NewsItem {
  final String id;
  final String title;
  final String content;
  final String summary;
  final String author;
  final String department;
  final DateTime publishDate;
  final List<String> tags;
  final String imageUrl;
  final Color categoryColor;
  final NewsCategory category;
  final int views;

  NewsItem({
    required this.id,
    required this.title,
    required this.content,
    required this.summary,
    required this.author,
    required this.department,
    required this.publishDate,
    required this.tags,
    required this.imageUrl,
    required this.categoryColor,
    required this.category,
    this.views = 0,
  });
}

enum NewsCategory {
  general,
  academic,
  research,
  events,
  sports,
  student,
}

extension NewsCategoryExtension on NewsCategory {
  String get displayName {
    switch (this) {
      case NewsCategory.general:
        return 'عام';
      case NewsCategory.academic:
        return 'أكاديمي';
      case NewsCategory.research:
        return 'بحثي';
      case NewsCategory.events:
        return 'فعاليات';
      case NewsCategory.sports:
        return 'رياضي';
      case NewsCategory.student:
        return 'طلابي';
    }
  }
}

