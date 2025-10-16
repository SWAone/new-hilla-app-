import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../models/college_model.dart';
import '../../core/theme/app_colors.dart';
import 'animated_card.dart';

class CollegeCard extends StatelessWidget {
  final College college;
  final VoidCallback? onTap;
  final int animationDelay;

  const CollegeCard({
    Key? key,
    required this.college,
    this.onTap,
    this.animationDelay = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedCard(
      onTap: onTap,
      delay: animationDelay,
      backgroundColor: college.primaryColor.withOpacity(0.1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header with icon and title
          Row(
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      college.primaryColor,
                      college.secondaryColor,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: college.primaryColor.withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  _getCollegeIcon(college.iconPath),
                  color: AppColors.textOnPrimary,
                  size: 24.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      college.name,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${college.departments.length} قسم',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: college.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 8.h),
          
          // Description
          Text(
            college.description,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              height: 1.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          
          SizedBox(height: 12.h),
          
          // Footer with departments count and arrow
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: college.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  '${college.departments.length} أقسام',
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: college.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  color: college.primaryColor,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.textOnPrimary,
                  size: 14.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getCollegeIcon(String iconPath) {
    switch (iconPath) {
      case 'medical':
        return Icons.medical_services;
      case 'engineering':
        return Icons.engineering;
      case 'science':
        return Icons.science;
      case 'arts':
        return Icons.palette;
      case 'education':
        return Icons.school;
      case 'business':
        return Icons.business;
      default:
        return Icons.school;
    }
  }
}
