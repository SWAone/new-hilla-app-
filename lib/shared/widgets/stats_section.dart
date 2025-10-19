import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';
import 'animated_card.dart';

class StatsSection extends StatelessWidget {
  final List<StatItem> stats;

  const StatsSection({
    Key? key,
    required this.stats,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          // Row(
          //   children: [
          //     Icon(
          //       Icons.analytics_rounded,
          //       color: AppColors.primary,
          //       size: 24.sp,
          //     ),
          //     SizedBox(width: 8.w),
          //     Text(
          //       'إحصائيات الجامعة',
          //       style: TextStyle(
          //         fontSize: 18.sp,
          //         fontWeight: FontWeight.bold,
          //         color: AppColors.textPrimary,
          //       ),
          //     ),
          //   ],
          // ),
          
          // SizedBox(height: 16.h),
          
          // Stats Grid
          // GridView.builder(
          //   shrinkWrap: true,
          //   physics: const NeverScrollableScrollPhysics(),
          //   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          //     crossAxisCount: 2,
          //     crossAxisSpacing: 0.w,
          //     mainAxisSpacing: 0.h,
          //     childAspectRatio: 1.3,
          //     mainAxisExtent: 190.h
          //   ),
          //   itemCount: stats.length,
          //   itemBuilder: (context, index) {
          //     final stat = stats[index];
          //     return AnimatedCard(
          //       delay: index * 100,
          //       child: _buildStatCard(stat),
          //     );
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildStatCard(StatItem stat) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            stat.primaryColor.withOpacity(0.1),
            stat.secondaryColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: stat.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon and Value
            Row(
              children: [
                Container(
                  width: 36.w,
                  height: 36.w,
                  decoration: BoxDecoration(
                    color: stat.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    stat.icon,
                    color: stat.primaryColor,
                    size: 18.sp,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    stat.value,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 8.h),
            
            // Title
            Text(
              stat.title,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            
            SizedBox(height: 2.h),
            
            // Description
            Text(
              stat.description,
              style: TextStyle(
                fontSize: 11.sp,
                color: AppColors.textSecondary,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class StatItem {
  final String title;
  final String description;
  final String value;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;

  StatItem({
    required this.title,
    required this.description,
    required this.value,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
  });
}
