import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import '../../models/news_model.dart';
import 'animated_card.dart';

class QuickNewsSection extends StatelessWidget {
  final List<NewsItem> news;
  final VoidCallback? onSeeAll;
  final ValueChanged<NewsItem>? onNewsTap;

  const QuickNewsSection({
    Key? key,
    required this.news,
    this.onSeeAll,
    this.onNewsTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(
                Icons.newspaper_rounded,
                color: AppColors.secondary,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'أحدث الأخبار',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: onSeeAll,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Text(
                    'عرض الكل',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 16.h),
          
          // News List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: news.take(3).length,
            itemBuilder: (context, index) {
              final newsItem = news[index];
              return AnimatedCard(
                delay: index * 100,
                margin: EdgeInsets.only(bottom: 12.h),
                onTap: () => onNewsTap?.call(newsItem),
                child: _buildNewsItem(newsItem),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem(NewsItem newsItem) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: newsItem.categoryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Image
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              boxShadow: [
                BoxShadow(
                  color: newsItem.categoryColor.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: newsItem.imageUrl != null && newsItem.imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Image.network(
                      newsItem.imageUrl!,
                      fit: BoxFit.cover,
                      cacheWidth: 200,
                      cacheHeight: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            color: newsItem.categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Icon(
                            _getNewsIcon(newsItem.category),
                            color: newsItem.categoryColor,
                            size: 24.sp,
                          ),
                        );
                      },
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          decoration: BoxDecoration(
                            color: newsItem.categoryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 16.w,
                              height: 16.w,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: newsItem.categoryColor,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: newsItem.categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Icon(
                      _getNewsIcon(newsItem.category),
                      color: newsItem.categoryColor,
                      size: 24.sp,
                    ),
                  ),
          ),
          
          SizedBox(width: 12.w),
          
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category Badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: newsItem.categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    newsItem.category.displayName,
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.bold,
                      color: newsItem.categoryColor,
                    ),
                  ),
                ),
                
                SizedBox(height: 6.h),
                
                // Title
                Text(
                  newsItem.title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                
                SizedBox(height: 4.h),
                
                // Meta Info
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 12.sp,
                      color: AppColors.textHint,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      _formatDate(newsItem.publishDate),
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Icon(
                      Icons.visibility,
                      size: 12.sp,
                      color: AppColors.textHint,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${newsItem.views}',
                      style: TextStyle(
                        fontSize: 10.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Arrow
          Icon(
            Icons.arrow_forward_ios,
            color: AppColors.textHint,
            size: 16.sp,
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
      return '${difference.inDays}د';
    } else {
      return '${date.day}/${date.month}';
    }
  }

  IconData _getNewsIcon(NewsCategory category) {
    switch (category) {
      case NewsCategory.general:
        return Icons.newspaper_rounded;
      case NewsCategory.academic:
        return Icons.school_rounded;
      case NewsCategory.research:
        return Icons.science_rounded;
      case NewsCategory.events:
        return Icons.event_rounded;
      case NewsCategory.sports:
        return Icons.sports_rounded;
      case NewsCategory.student:
        return Icons.person_rounded;
    }
  }
}















