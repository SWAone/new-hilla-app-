import 'package:get/get.dart';
import '../../core/controllers/base_controller.dart';
import '../../models/news_model.dart';
import '../../data/news_data.dart';

class NewsController extends BaseController {
  final RxList<NewsItem> news = <NewsItem>[].obs;
  final RxList<NewsItem> filteredNews = <NewsItem>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isSearching = false.obs;
  final Rx<NewsCategory?> selectedCategory = Rx<NewsCategory?>(null);

  @override
  void onInit() {
    super.onInit();
    loadNews();
  }

  Future<void> loadNews() async {
    try {
      setLoading(true);
      clearError();
      
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 800));
      
      news.value = NewsData.getNews();
      filteredNews.value = news;
      
    } catch (e) {
      setError('فشل في تحميل الأخبار: ${e.toString()}');
      showErrorSnackBar('فشل في تحميل الأخبار');
    } finally {
      setLoading(false);
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
    return NewsData.getLatestNews(limit: limit);
  }

  List<NewsItem> getNewsByCategory(NewsCategory category) {
    return news.where((item) => item.category == category).toList();
  }
}

