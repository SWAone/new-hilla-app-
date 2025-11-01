import 'package:get/get.dart';
import '../../core/controllers/base_controller.dart';
import '../../models/news_model.dart';
// import '../../data/news_data.dart';
import '../../data/news_repository.dart';
import '../../models/news.dart' as api;
import 'package:flutter/material.dart';

class NewsController extends BaseController {
  final RxList<NewsItem> news = <NewsItem>[].obs;
  final RxList<NewsItem> filteredNews = <NewsItem>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isSearching = false.obs;
  final Rx<NewsCategory?> selectedCategory = Rx<NewsCategory?>(null);

  final NewsRepository _repo = NewsRepository();

  @override
  void onInit() {
    super.onInit();
    loadNews();
  }

  Future<void> loadNews() async {
    try {
      setLoading(true);
      clearError();
      final result = await _repo.fetchNews(page: 1, limit: 10);
      final items = result.items.map(_convertToNewsItem).toList();
      news.value = items;
      filteredNews.value = items;
      
    } catch (e) {
      setError('فشل في تحميل الأخبار: ${e.toString()}');
      showErrorSnackBar('فشل في تحميل الأخبار');
    } finally {
      setLoading(false);
    }
  }

  NewsItem _convertToNewsItem(api.News n) {
    final category = _mapCategory(n.category);
    return NewsItem(
      id: n.id,
      title: n.title,
      content: n.summary ?? '',
      summary: n.summary ?? '',
      author: '',
      department: '',
      publishDate: n.publishDate ?? DateTime.now(),
      tags: const <String>[],
      imageUrl: n.thumbnailUrl ?? '',
      categoryColor: _categoryColor(category),
      category: category,
      views: n.views ?? 0,
    );
  }

  NewsCategory _mapCategory(String? c) {
    switch ((c ?? '').toLowerCase()) {
      case 'academic':
        return NewsCategory.academic;
      case 'research':
        return NewsCategory.research;
      case 'events':
        return NewsCategory.events;
      case 'sports':
        return NewsCategory.sports;
      case 'student':
        return NewsCategory.student;
      case 'general':
      default:
        return NewsCategory.general;
    }
  }

  Color _categoryColor(NewsCategory c) {
    switch (c) {
      case NewsCategory.academic:
        return const Color(0xFF1976D2);
      case NewsCategory.research:
        return const Color(0xFF7B1FA2);
      case NewsCategory.events:
        return const Color(0xFF2196F3);
      case NewsCategory.sports:
        return const Color(0xFF4CAF50);
      case NewsCategory.student:
        return const Color(0xFF2E7D32);
      case NewsCategory.general:
        return const Color(0xFF795548);
    }
  }

  void searchNews(String query) {
    searchQuery.value = query;
    isSearching.value = query.isNotEmpty;
    
    if (query.isEmpty && selectedCategory.value == null) {
      filteredNews.value = news;
    } else {
      filteredNews.value = news.where((item) {
        final matchesSearch = query.isEmpty || 
            item.title.toLowerCase().contains(query.toLowerCase()) ||
            item.content.toLowerCase().contains(query.toLowerCase()) ||
            item.tags.any((tag) => tag.toLowerCase().contains(query.toLowerCase()));
        
        final matchesCategory = selectedCategory.value == null || 
            item.category == selectedCategory.value;
        
        return matchesSearch && matchesCategory;
      }).toList();
    }
  }

  void filterByCategory(NewsCategory? category) {
    selectedCategory.value = category;
    searchNews(searchQuery.value);
  }

  void clearSearch() {
    searchQuery.value = '';
    isSearching.value = false;
    selectedCategory.value = null;
    filteredNews.value = news;
  }

  NewsItem? getNewsById(String id) {
    try {
      return news.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  List<NewsItem> getLatestNews({int limit = 5}) {
    final items = [...news];
    items.sort((a, b) => b.publishDate.compareTo(a.publishDate));
    return items.take(limit).toList();
  }

  List<NewsItem> getNewsByCategory(NewsCategory category) {
    return news.where((item) => item.category == category).toList();
  }
}

