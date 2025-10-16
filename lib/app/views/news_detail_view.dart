import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../app/controllers/news_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../models/news_model.dart';
import '../../shared/widgets/animated_card.dart';

class NewsDetailView extends StatelessWidget {
  final String newsId;

  const NewsDetailView({
    Key? key,
    required this.newsId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final NewsController controller = Get.find<NewsController>();
    final news = controller.getNewsById(newsId);

    if (news == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('خطأ'),
        ),
        body: Center(
          child: Text('الخبر غير موجود'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 200.h,
            pinned: true,
            backgroundColor: news.categoryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                news.category.displayName,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textOnPrimary,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      news.categoryColor,
                      news.categoryColor.withOpacity(0.8),
                    ],
                  ),
                ),
                child: Center(
                  child: Container(
                    width: 80.w,
                    height: 80.w,
                    decoration: BoxDecoration(
                      color: AppColors.textOnPrimary.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Icon(
                      Icons.newspaper_rounded,
                      color: AppColors.textOnPrimary,
                      size: 40.sp,
                    ),
                  ),
                ),
              ),
            ),
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.r),
                  topRight: Radius.circular(24.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Meta Info
                  _buildHeader(news),
                  
                  // Content
                  _buildContent(news),
                  
                  // Tags
                  _buildTags(news),
                  
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(news) {
    return AnimatedCard(
      delay: 0,
      margin: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            news.title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Meta Info
          Row(
            children: [
              _buildMetaItem(
                icon: Icons.person,
                label: news.author,
                color: news.categoryColor,
              ),
              SizedBox(width: 16.w),
              _buildMetaItem(
                icon: Icons.account_balance,
                label: news.department,
                color: news.categoryColor,
              ),
            ],
          ),
          
          SizedBox(height: 12.h),
          
          Row(
            children: [
              _buildMetaItem(
                icon: Icons.access_time,
                label: _formatDate(news.publishDate),
                color: news.categoryColor,
              ),
              SizedBox(width: 16.w),
              _buildMetaItem(
                icon: Icons.visibility,
                label: '${news.views} مشاهدة',
                color: news.categoryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetaItem({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16.sp,
          color: color,
        ),
        SizedBox(width: 4.w),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildContent(news) {
    return AnimatedCard(
      delay: 100,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.article,
                color: news.categoryColor,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'محتوى الخبر',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            news.content,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags(news) {
    return AnimatedCard(
      delay: 200,
      margin: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tag,
                color: news.categoryColor,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'العلامات',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: news.tags.map((tag) => Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: news.categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: news.categoryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: news.categoryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'اليوم';
    } else if (difference.inDays == 1) {
      return 'أمس';
    } else if (difference.inDays < 7) {
      return 'منذ ${difference.inDays} أيام';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
