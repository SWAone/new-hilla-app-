import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../app/controllers/news_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../models/news_model.dart';
import '../../shared/widgets/news_card.dart';
import 'news_detail_view.dart';

class NewsView extends StatefulWidget {
  const NewsView({Key? key}) : super(key: key);

  @override
  State<NewsView> createState() => _NewsViewState();
}

class _NewsViewState extends State<NewsView> {
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
    _searchFocusNode.addListener(() {
      final NewsController controller = Get.find<NewsController>();
      if (!_searchFocusNode.hasFocus && controller.searchQuery.value.isEmpty) {
        controller.isSearching.value = false;
      }
    });
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final NewsController controller = Get.find<NewsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Search and Filter
            _buildSearchAndFilter(controller),
            
            // Content
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return _buildLoadingState();
                }
                
                if (controller.hasError.value) {
                  return _buildErrorState(controller);
                }
                
                if (controller.filteredNews.isEmpty) {
                  return _buildEmptyState();
                }
                
                return _buildNewsList(controller);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              gradient: AppColors.secondaryGradient,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.newspaper_rounded,
              color: AppColors.textOnPrimary,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أخبار الجامعة',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'آخر الأخبار والمستجدات',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter(NewsController controller) {
    return Container(
      padding: EdgeInsets.only(top: 20.h, bottom: 24.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.background,
            AppColors.background.withOpacity(0.95),
          ],
        ),
      ),
      child: Column(
        children: [
          // Modern Search Bar with Glassmorphism Effect
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Obx(() => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24.r),
                gradient: controller.isSearching.value
                    ? LinearGradient(
                        colors: [
                          AppColors.surface,
                          AppColors.surface.withOpacity(0.9),
                        ],
                      )
                    : null,
                color: controller.isSearching.value ? null : AppColors.surface,
                boxShadow: [
                  BoxShadow(
                    color: controller.isSearching.value
                        ? AppColors.primary.withOpacity(0.15)
                        : AppColors.shadowLight,
                    blurRadius: controller.isSearching.value ? 20 : 10,
                    spreadRadius: controller.isSearching.value ? 2 : 0,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: controller.isSearching.value
                      ? AppColors.primary.withOpacity(0.3)
                      : Colors.transparent,
                  width: 1.5,
                ),
              ),
              child: TextField(
                
                focusNode: _searchFocusNode,
                onChanged: (value) {
                  controller.searchNews(value);
                  if (value.isNotEmpty) {
                    controller.isSearching.value = true;
                  }
                },
                onTap: () => controller.isSearching.value = true,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration( 
                  hintText: 'ابحث في الأخبار...',
                  hintStyle: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textHint,
                    fontWeight: FontWeight.w400,
                  ),
                  prefixIcon: Container(
                    margin: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.search_rounded,
                      color: AppColors.textOnPrimary,
                      size: 20.sp,
                    ),
                  ),
                  suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
                      ? AnimatedScale(
                          scale: 1.0,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.easeInOut,
                          child: Container(
                            margin: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: AppColors.error.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10.r),
                            ),
                            child: IconButton(
                              icon: Icon(
                                Icons.close_rounded,
                                color: AppColors.error,
                                size: 20.sp,
                              ),
                              onPressed: () {
                                _searchFocusNode.unfocus();
                                controller.clearSearch();
                              },
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(),
                            ),
                          ),
                        )
                      : const SizedBox.shrink()),
                  filled: true,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8.w,
                    vertical: 18.h,
                  ),
                ),
              ),
            )),
          ),
          
          SizedBox(height: 20.h),
          

       
          // Modern Category Filter with Smooth Scrolling
          Obx(() {
            final selectedCategory = controller.selectedCategory.value;
            return Container(
              height: 70.h,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                physics: const BouncingScrollPhysics(),
                itemCount: NewsCategory.values.length + 1,
                separatorBuilder: (context, index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 12.w,
                ),
                itemBuilder: (context, index) {
                  if (index == 0) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOutCubic,
                      child: _buildCategoryChip(
                        label: 'الكل',
                        icon: Icons.apps_rounded,
                        isSelected: selectedCategory == null,
                        onTap: () => controller.filterByCategory(null),
                      ),
                    );
                  }
                  final category = NewsCategory.values[index - 1];
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 300 + (index * 20)),
                    curve: Curves.easeOutCubic,
                    child: _buildCategoryChip(
                      label: category.displayName,
                      icon: _getCategoryIcon(category),
                      isSelected: selectedCategory == category,
                      onTap: () => controller.filterByCategory(category),
                    ),
                  );
                },
              ),
            );
          }),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(NewsCategory category) {
    switch (category) {
      case NewsCategory.academic:
        return Icons.school_rounded;
      case NewsCategory.research:
        return Icons.science_rounded;
      case NewsCategory.events:
        return Icons.event_rounded;
      case NewsCategory.sports:
        return Icons.sports_soccer_rounded;
      case NewsCategory.student:
        return Icons.people_rounded;
      case NewsCategory.general:
        return Icons.article_rounded;
    }
  }

  Widget _buildCategoryChip({
    required String label,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: isSelected ? 1.0 : 0.0),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeInOutCubicEmphasized,
      builder: (context, value, child) {
        // حساب قيمة للانيميشن الناعم
        final smoothValue = Curves.easeInOutCubicEmphasized.transform(value);
        
        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24.r),
            splashColor: AppColors.primary.withOpacity(0.2),
            highlightColor: AppColors.primary.withOpacity(0.1),
            child: AnimatedScale(
              scale: isSelected ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOutBack,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color.lerp(
                              AppColors.surface,
                              AppColors.primary,
                              smoothValue,
                            )!,
                            Color.lerp(
                              AppColors.surface,
                              AppColors.primaryLight,
                              smoothValue,
                            )!,
                          ],
                        )
                      : null,
                  color: isSelected ? null : AppColors.surface,
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    // // Shadow ناعم وحديث للمحدد
                    // if (isSelected)
                    //   BoxShadow(
                    //     color: AppColors.primary.withOpacity(0.15 * smoothValue),
                    //     blurRadius: 18 + (smoothValue * 12),
                    //     spreadRadius: smoothValue * 0.3,
                    //     offset: Offset(0, 4 + (smoothValue * 2)),
                    //   ),
                    // // Shadow خفيف للغير محدد - يختفي تدريجياً عند التحديد
                    // if (!isSelected || smoothValue < 0.6)
                    //   BoxShadow(
                    //     color: AppColors.shadowLight.withOpacity((1 - smoothValue) * 0.12),
                    //     blurRadius: 10,
                    //     spreadRadius: 0,
                    //     offset: const Offset(0, 2),
                    //   ),
                  ],
                  // إزالة الحدود تماماً للحصول على تصميم أكثر نعومة
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon with enhanced animation
                    TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0.0, end: smoothValue),
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeOutCubic,
                      builder: (context, iconValue, child) {
                        // التأكد من أن القيمة في النطاق الصحيح (0.0 - 1.0) لتجنب أخطاء withOpacity
                        final clampedValue = iconValue.clamp(0.0, 1.0);
                        final iconScale = 1.0 + (clampedValue * 0.2);
                        final iconRotation = clampedValue * 0.2;
                        // التأكد من أن opacity في النطاق الصحيح (0.0 - 1.0)
                        final opacity = (clampedValue * 0.1).clamp(0.0, 1.0);
                        
                        return Transform.scale(
                          scale: iconScale,
                          child: Transform.rotate(
                            angle: iconRotation,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              padding: EdgeInsets.all(clampedValue * 2),
                              decoration: BoxDecoration(
                                color: AppColors.textOnPrimary.withOpacity(opacity),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                icon,
                                size: 18.sp,
                                color: Color.lerp(
                                  AppColors.textSecondary,
                                  AppColors.textOnPrimary,
                                  smoothValue,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 8.w),
                    // Text with smooth animation
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOutCubic,
                      style: TextStyle(
                        fontSize: 14.sp + (smoothValue * 1.0),
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: Color.lerp(
                          AppColors.textSecondary,
                          AppColors.textOnPrimary,
                          smoothValue,
                        )!,
                        letterSpacing: 0.3 + (smoothValue * 0.3),
                        shadows: isSelected
                            ? [
                                Shadow(
                                  color: AppColors.textOnPrimary.withOpacity(0.3 * smoothValue),
                                  blurRadius: 4 * smoothValue,
                                ),
                              ]
                            : null,
                      ),
                      child: Text(label),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
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
            'جاري تحميل الأخبار...',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(NewsController controller) {
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
            'حدث خطأ في تحميل الأخبار',
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
            onPressed: controller.loadNews,
            child: Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.newspaper_outlined,
            size: 64.sp,
            color: AppColors.textHint,
          ),
          SizedBox(height: 16.h),
          Text(
            'لا توجد أخبار',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'جرب البحث بكلمات مختلفة',
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsList(NewsController controller) {
    return Obx(() {
      final selectedCategory = controller.selectedCategory.value;
      final categoryKey = selectedCategory?.toString() ?? 'all';
      
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.05),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            ),
          );
        },
        child: ListView.builder(
          key: ValueKey(categoryKey),
          padding: EdgeInsets.all(20.w),
          itemCount: controller.filteredNews.length,
          itemBuilder: (context, index) {
            final news = controller.filteredNews[index];
            return NewsCard(
              key: ValueKey('${news.id}_$categoryKey'),
              news: news,
              animationDelay: index * 80,
              onTap: () => Get.to(
                () => NewsDetailView(newsId: news.id),
                transition: Transition.rightToLeft,
                duration: const Duration(milliseconds: 300),
              ),
            );
          },
        ),
      );
    });
  }

}
