import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../app/controllers/college_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../models/college_model.dart';
import '../../shared/widgets/department_card.dart';
import 'department_detail_view.dart';

class CollegeDetailView extends StatelessWidget {
  final String collegeId;

  const CollegeDetailView({
    Key? key,
    required this.collegeId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CollegeController controller = Get.find<CollegeController>();
    final College? college = controller.getCollegeById(collegeId);

    if (college == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('خطأ'),
        ),
        body: Center(
          child: Text('الكلية غير موجودة'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar with Hero Image
          SliverAppBar(
            expandedHeight: 300.h,
            pinned: true,
            backgroundColor: college.primaryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                college.name,
                style: TextStyle(
                  fontSize: 18.sp,
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
                      college.primaryColor,
                      college.secondaryColor,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Background Pattern
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              college.primaryColor.withOpacity(0.3),
                              college.secondaryColor.withOpacity(0.2),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Overlay
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              college.primaryColor.withOpacity(0.8),
                            ],
                          ),
                        ),
                      ),
                    ),
                    // Icon
                    Center(
                      child: Container(
                        width: 80.w,
                        height: 80.w,
                        decoration: BoxDecoration(
                          color: AppColors.textOnPrimary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Icon(
                          _getCollegeIcon(college.iconPath),
                          color: AppColors.textOnPrimary,
                          size: 40.sp,
                        ),
                      ),
                    ),
                  ],
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
                  // Description
                  _buildDescriptionSection(college),
                  
                  // Departments Section
                  _buildDepartmentsSection(college),
                  
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(College college) {
    return Container(
      margin: EdgeInsets.all(20.w),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: college.primaryColor,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'عن الكلية',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            college.description,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              _buildInfoChip(
                icon: Icons.account_balance,
                label: '${college.departments.length} قسم',
                color: college.primaryColor,
              ),
              SizedBox(width: 12.w),
              _buildInfoChip(
                icon: Icons.people,
                label: '${_getTotalStudents(college)} طالب',
                color: college.secondaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16.sp,
            color: color,
          ),
          SizedBox(width: 4.w),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDepartmentsSection(College college) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.account_balance,
                color: college.primaryColor,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'الأقسام',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: college.departments.length,
            itemBuilder: (context, index) {
              final department = college.departments[index];
              return DepartmentCard(
                department: department,
                primaryColor: college.primaryColor,
                animationDelay: index * 100,
                onTap: () => Get.to(
                  () => DepartmentDetailView(
                    department: department,
                    collegeColor: college.primaryColor,
                  ),
                  transition: Transition.rightToLeft,
                  duration: const Duration(milliseconds: 300),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  int _getTotalStudents(College college) {
    return college.departments.fold(0, (sum, dept) => sum + dept.studentCount);
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
