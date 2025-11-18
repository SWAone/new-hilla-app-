import 'package:flutter/material.dart';
import '../models/news_model.dart';

class NewsData {
  static List<NewsItem> getNews() {
    return [
      NewsItem(
        id: '1',
        title: 'افتتاح مختبر التكنولوجيا المتقدمة في كلية الهندسة',
        content: 'تم افتتاح مختبر التكنولوجيا المتقدمة في كلية الهندسة بجامعة الحلة، والذي يضم أحدث المعدات والتقنيات في مجال الهندسة والتكنولوجيا. المختبر سيساهم في تطوير البحث العلمي وتدريب الطلاب على أحدث التقنيات.',
        summary: 'افتتاح مختبر جديد في كلية الهندسة بأحدث المعدات والتقنيات',
        author: 'د. أحمد محمد',
        publishDate: DateTime.now().subtract(const Duration(days: 2)),
        tags: ['تقنية', 'هندسة', 'مختبرات', 'بحث علمي'],
        imageUrl: '',
        categoryColor: const Color(0xFF1976D2),
        category: NewsCategory.academic,
        views: 156,
      ),
      NewsItem(
        id: '2',
        title: 'نتائج مسابقة البحث العلمي السنوية',
        content: 'أعلنت جامعة الحلة عن نتائج مسابقة البحث العلمي السنوية التي شارك فيها أكثر من 50 باحث من مختلف الكليات. فاز بالمركز الأول بحث حول تطوير تقنيات الطاقة المتجددة.',
        summary: 'إعلان نتائج مسابقة البحث العلمي السنوية',
        author: 'د. فاطمة علي',
        publishDate: DateTime.now().subtract(const Duration(days: 5)),
        tags: ['بحث علمي', 'مسابقة', 'طاقة متجددة', 'إنجازات'],
        imageUrl: '',
        categoryColor: const Color(0xFF7B1FA2),
        category: NewsCategory.research,
        views: 234,
      ),
      NewsItem(
        id: '3',
        title: 'انطلاق الدوري الرياضي الجامعي',
        content: 'انطلق الدوري الرياضي الجامعي بمشاركة فرق من جميع الكليات في مختلف الألعاب الرياضية. المسابقة تستمر لمدة شهر وتشمل كرة القدم، كرة السلة، والسباحة.',
        summary: 'انطلاق الدوري الرياضي الجامعي بمشاركة جميع الكليات',
        author: 'أ. محمد حسن',
        publishDate: DateTime.now().subtract(const Duration(days: 7)),
        tags: ['رياضة', 'دوري', 'طلاب', 'نشاط'],
        imageUrl: '',
        categoryColor: const Color(0xFF4CAF50),
        category: NewsCategory.sports,
        views: 189,
      ),
      NewsItem(
        id: '4',
        title: 'ورشة عمل حول الذكاء الاصطناعي في التعليم',
        content: 'نظمت كلية العلوم ورشة عمل حول استخدام الذكاء الاصطناعي في التعليم، حضرها أكثر من 100 من أعضاء هيئة التدريس والطلاب. الورشة تناولت أحدث التطورات في هذا المجال.',
        summary: 'ورشة عمل حول الذكاء الاصطناعي في التعليم',
        author: 'د. سارة أحمد',
        publishDate: DateTime.now().subtract(const Duration(days: 10)),
        tags: ['ذكاء اصطناعي', 'تعليم', 'ورشة عمل', 'تقنية'],
        imageUrl: '',
        categoryColor: const Color(0xFF2196F3),
        category: NewsCategory.academic,
        views: 298,
      ),
      NewsItem(
        id: '5',
        title: 'حفل تخرج الدفعة الجديدة من طلاب الطب',
        content: 'احتفلت كلية الطب بتخرج الدفعة الجديدة من طلاب الطب، والتي تضم 120 طبيباً جديداً. الحفل حضره عدد من المسؤولين في وزارة الصحة ورئيس الجامعة.',
        summary: 'تخرج 120 طبيباً جديداً من كلية الطب',
        author: 'د. خالد محمد',
        publishDate: DateTime.now().subtract(const Duration(days: 14)),
        tags: ['تخرج', 'طب', 'احتفال', 'إنجاز'],
        imageUrl: '',
        categoryColor: const Color(0xFF2E7D32),
        category: NewsCategory.general,
        views: 445,
      ),
      NewsItem(
        id: '6',
        title: 'مؤتمر التعليم العالي والتنمية المستدامة',
        content: 'استضافت جامعة الحلة مؤتمر التعليم العالي والتنمية المستدامة بمشاركة جامعات عراقية وعربية. المؤتمر ناقش دور التعليم في تحقيق أهداف التنمية المستدامة.',
        summary: 'مؤتمر حول التعليم العالي والتنمية المستدامة',
        author: 'د. علي محمود',
        publishDate: DateTime.now().subtract(const Duration(days: 20)),
        tags: ['مؤتمر', 'تعليم عالي', 'تنمية مستدامة', 'تعاون'],
        imageUrl: '',
        categoryColor: const Color(0xFF795548),
        category: NewsCategory.academic,
        views: 312,
      ),
    ];
  }

  static List<NewsItem> getNewsByCategory(NewsCategory category) {
    return getNews().where((news) => news.category == category).toList();
  }

  static List<NewsItem> getLatestNews({int limit = 5}) {
    final news = getNews();
    news.sort((a, b) => b.publishDate.compareTo(a.publishDate));
    return news.take(limit).toList();
  }
}

