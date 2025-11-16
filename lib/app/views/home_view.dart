import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../app/controllers/college_controller.dart';
import '../../app/controllers/news_controller.dart';
import '../../app/controllers/events_controller.dart';
import '../../app/controllers/slider_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../shared/widgets/modern_college_card.dart';
import '../../shared/widgets/hero_slider.dart';
import '../../shared/widgets/stats_section.dart';
import '../../shared/widgets/quick_news_section.dart';
import '../../shared/widgets/quick_events_section.dart';
import '../../360_views/screens/virtual_tour_screen.dart';
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
    final SliderController sliderController = Get.find<SliderController>();

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
                _buildHeroSlider(sliderController),
                
                SizedBox(height: 20.h),
                
                // Virtual Tour Button
                _buildVirtualTourButton(),
                
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

  Widget _buildHeroSlider(SliderController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return Container(
          height: 250.h,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ),
        );
      }

      return HeroSlider(
        items: controller.sliderItems.toList(),
      );
    });
  }

  Widget _buildVirtualTourButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Get.to(
              () => const VirtualTourScreen(),
              transition: Transition.fadeIn,
              duration: const Duration(milliseconds: 300),
            );
          },
          borderRadius: BorderRadius.circular(20.r),
          child: Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primary,
                  AppColors.primaryLight,
                  AppColors.secondary,
                ],
              ),
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
                BoxShadow(
                  color: AppColors.shadowMedium,
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Icon Container
                Container(
                  width: 56.w,
                  height: 56.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: Icon(
                    Icons.explore_rounded,
                    color: Colors.white,
                    size: 28.sp,
                  ),
                ),
                
                SizedBox(width: 16.w),
                
                // Text Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'التجول الافتراضي في الجامعة',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'استكشف الجامعة بجولة 360 درجة',
                        style: TextStyle(
                          fontSize: 13.sp,
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Arrow Icon
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
        value: '19+',
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
