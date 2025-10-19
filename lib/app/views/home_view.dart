import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../app/controllers/college_controller.dart';
import '../../app/controllers/news_controller.dart';
import '../../app/controllers/events_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/modern_college_card.dart';
import '../../shared/widgets/hero_slider.dart';
import '../../shared/widgets/stats_section.dart';
import '../../shared/widgets/quick_news_section.dart';
import '../../shared/widgets/quick_events_section.dart';
import 'college_detail_view.dart';

class HomeView extends StatelessWidget {
  final VoidCallback? onNavigateToNews;
  final VoidCallback? onNavigateToEvents;

  const HomeView({
    Key? key,
    this.onNavigateToNews,
    this.onNavigateToEvents,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CollegeController collegeController = Get.find<CollegeController>();
    final NewsController newsController = Get.find<NewsController>();
    final EventsController eventsController = Get.find<EventsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          if (collegeController.isLoading.value) {
            return _buildLoadingState();
          }
          
          if (collegeController.hasError.value) {
            return _buildErrorState(collegeController);
          }
          
          return SingleChildScrollView(
            child: Column(
              children: [
                // Hero Slider
                _buildHeroSlider(),
                
                SizedBox(height: 24.h),
                
                // Stats Section
                _buildStatsSection(),
                
                SizedBox(height: 24.h),
                
                // Quick News Section
                _buildQuickNewsSection(newsController),
                
                SizedBox(height: 24.h),
                
                // Quick Events Section
                _buildQuickEventsSection(eventsController),
                
                SizedBox(height: 24.h),
                
                // Colleges Section
                _buildCollegesSection(collegeController),
                
                SizedBox(height: 20.h),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeroSlider() {
    final sliderItems = [
      SliderItem(
        title: 'مرحباً بك في جامعة الحلة',
        description: 'جامعة عراقية رائدة في التعليم والبحث العلمي',
        icon: Icons.school_rounded,
        primaryColor: AppColors.primary,
        secondaryColor: AppColors.primaryLight,
        buttonText: 'استكشف الجامعة',
        imageUrl: 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=800&h=600&fit=crop&auto=format',
      ),
      SliderItem(
        title: 'التعليم الرقمي',
        description: 'نوفر أحدث التقنيات في التعليم الإلكتروني',
        icon: Icons.computer_rounded,
        primaryColor: AppColors.secondary,
        secondaryColor: AppColors.secondaryLight,
        buttonText: 'تعلم الآن',
        imageUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&h=600&fit=crop&auto=format',
      ),
      SliderItem(
        title: 'البحث العلمي',
        description: 'مركز للابتكار والبحث في مختلف المجالات',
        icon: Icons.science_rounded,
        primaryColor: AppColors.accent,
        secondaryColor: AppColors.accentLight,
        buttonText: 'اكتشف المزيد',
        imageUrl: 'https://images.unsplash.com/photo-1532187863486-abf9dbad1b69?w=800&h=600&fit=crop&auto=format',
      ),
    ];

    return HeroSlider(
      items: sliderItems,
    );
  }

  Widget _buildStatsSection() {
    final stats = [
      StatItem(
        title: 'الطلاب',
        description: 'إجمالي الطلاب المسجلين',
        value: '15,000+',
        icon: Icons.people_rounded,
        primaryColor: AppColors.primary,
        secondaryColor: AppColors.primaryLight,
      ),
      StatItem(
        title: 'الكليات',
        description: 'عدد الكليات المتاحة',
        value: '6',
        icon: Icons.account_balance_rounded,
        primaryColor: AppColors.secondary,
        secondaryColor: AppColors.secondaryLight,
      ),
      StatItem(
        title: 'الأقسام',
        description: 'التخصصات المختلفة',
        value: '18+',
        icon: Icons.category_rounded,
        primaryColor: AppColors.accent,
        secondaryColor: AppColors.accentLight,
      ),
      StatItem(
        title: 'الأساتذة',
        description: 'أعضاء هيئة التدريس',
        value: '500+',
        icon: Icons.person_rounded,
        primaryColor: const Color(0xFF7B1FA2),
        secondaryColor: const Color(0xFFBA68C8),
      ),
    ];

    return StatsSection(stats: stats);
  }

  Widget _buildQuickNewsSection(NewsController controller) {
    final latestNews = controller.getLatestNews(limit: 3);
    return QuickNewsSection(
      news: latestNews,
      onSeeAll: onNavigateToNews,
    );
  }

  Widget _buildQuickEventsSection(EventsController controller) {
    final upcomingEvents = controller.getUpcomingEvents().take(3).toList();
    return QuickEventsSection(
      events: upcomingEvents,
      onSeeAll: onNavigateToEvents,
    );
  }

  Widget _buildCollegesSection(CollegeController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.school_rounded,
                color: AppColors.primary,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'كليات الجامعة',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // Colleges List
          Obx(() => ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.filteredColleges.length,
            itemBuilder: (context, index) {
              final college = controller.filteredColleges[index];
              return ModernCollegeCard(
                college: college,
                animationDelay: index * 100,
                onTap: () => Get.to(
                  () => CollegeDetailView(collegeId: college.id),
                  transition: Transition.rightToLeft,
                  duration: const Duration(milliseconds: 300),
                ),
              );
            },
          )),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
          SizedBox(height: 16.h),
          Text(
            'جاري تحميل البيانات...',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(CollegeController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64.sp,
            color: AppColors.error,
          ),
          SizedBox(height: 16.h),
          Text(
            'حدث خطأ في تحميل البيانات',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            controller.errorMessage.value,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: controller.loadColleges,
            child: Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

}
