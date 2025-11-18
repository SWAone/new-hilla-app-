import 'dart:async';

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

  final int _limit = 10;
  int _nextPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  String _currentSearchTerm = '';
  Timer? _searchDebounce;

  @override
  void onInit() {
    super.onInit();
    loadNews();
  }

  @override
  void onClose() {
    _searchDebounce?.cancel();
    super.onClose();
  }

  Future<void> loadNews({bool reset = true}) async {
    if (reset) {
      _nextPage = 1;
      _hasMore = true;
    } else {
      if (_isLoadingMore || !_hasMore) return;
    }

    if (reset) {
      setLoading(true);
    } else {
      _isLoadingMore = true;
    }

    try {
      clearError();
      // لا نرسل isPublished لأن السيرفر يقوم بتطبيقه تلقائيًا للمستخدمين العاديين
      final result = await _repo.fetchNews(
        page: _nextPage,
        limit: _limit,
        search: _currentSearchTerm.isNotEmpty ? _currentSearchTerm : null,
        category: selectedCategory.value?.name,
        isPublished: null, // السيرفر يقوم بتطبيق isPublished=true تلقائيًا
      );
      
      
      debugPrint('News loaded: ${result.items.length} items, total: ${result.total}, page: ${result.page}');
      final items = result.items.map(_convertToNewsItem).toList();

      if (reset) {
        news.value = items;
      } else {
        news.addAll(items);
      }
      filteredNews.value = news;

      _hasMore = result.hasNextPage;
      _nextPage = _hasMore ? result.page + 1 : result.page;
    } catch (e, stackTrace) {
      debugPrint('Error loading news: $e\n$stackTrace');
      setError('فشل في تحميل الأخبار: ${e.toString()}');
      showErrorSnackBar('فشل في تحميل الأخبار');
    } finally {
      if (reset) {
        setLoading(false);
      } else {
        _isLoadingMore = false;
      }
    }
  }

  NewsItem _convertToNewsItem(api.News n) {
    final category = _mapCategory(n.category);
    return NewsItem(
      id: n.id,
      title: n.title,
      content: n.content ?? n.summary ?? '',
      summary: n.summary ?? n.content ?? '',
      author: '',
      publishDate: n.publishDate ?? DateTime.now(),
      tags: const <String>[],
      imageUrl: n.thumbnailUrl,
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

    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 400), () {
      _currentSearchTerm = query.trim();
      loadNews();
    });
  }

  void filterByCategory(NewsCategory? category) {
    selectedCategory.value = category;
    loadNews();
  }

  void clearSearch() {
    searchQuery.value = '';
    isSearching.value = false;
    selectedCategory.value = null;
    _currentSearchTerm = '';
    loadNews();
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

