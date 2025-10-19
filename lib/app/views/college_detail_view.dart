import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../app/controllers/college_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../models/college_model.dart';
import '../../shared/widgets/department_card.dart';
import '../../shared/widgets/faculty_member_card.dart';
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
            stretch: true,
            flexibleSpace: FlexibleSpaceBar(
              stretchModes: const [
                StretchMode.zoomBackground,
                StretchMode.blurBackground,
                StretchMode.fadeTitle,
              ],
              title: Text(
                college.name,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
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
                    // Background Image
                    Positioned.fill(
                      child: college.imageUrl.isNotEmpty
                          ? Image.network(
                              college.imageUrl,
                              fit: BoxFit.cover,
                              headers: const {
                                'User-Agent': 'Mozilla/5.0 (compatible; Flutter App)',
                              },
                              cacheWidth: 800,
                              cacheHeight: 600,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
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
                                );
                              },
                            )
                          : Container(
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
                    
                    // Dark Overlay for better text visibility
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.6),
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
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          _getCollegeIcon(college.iconPath),
                          color: Colors.white,
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
                  
                  // Admission Guide Section
                  _buildAdmissionGuideSection(college),
                  
                  // Faculty Members Section
                  _buildFacultyMembersSection(college),
                  
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

  Widget _buildAdmissionGuideSection(College college) {
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
                Icons.school,
                color: college.primaryColor,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'دليل القبول',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          
          // Required GPA
          _buildGPARequirement(college.admissionGuide.requiredGPA, college.primaryColor),
          SizedBox(height: 16.h),
          
          // Requirements
          _buildRequirementsList(college.admissionGuide.requirements, college.primaryColor),
          SizedBox(height: 16.h),
          
          // Documents
          _buildDocumentsSection(college.admissionGuide.documents, college.primaryColor),
          SizedBox(height: 16.h),
          
          // Additional Info
          if (college.admissionGuide.additionalInfo.isNotEmpty)
            _buildAdditionalInfo(college.admissionGuide.additionalInfo, college.primaryColor),
        ],
      ),
    );
  }

  Widget _buildGPARequirement(double gpa, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            Icons.grade,
            color: color,
            size: 20.sp,
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'المعدل المطلوب',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  '$gpa',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirementsList(List<String> requirements, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'متطلبات القبول',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 8.h),
        ...requirements.map((requirement) => Padding(
          padding: EdgeInsets.only(bottom: 8.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 6.w,
                height: 6.w,
                margin: EdgeInsets.only(top: 6.h, right: 8.w),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
              ),
              Expanded(
                child: Text(
                  requirement,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildDocumentsSection(List<AdmissionDocument> documents, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الاستمارات المطلوبة',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 12.h),
        ...documents.map((document) => _buildDocumentCard(document, color)).toList(),
      ],
    );
  }

  Widget _buildDocumentCard(AdmissionDocument document, Color color) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              document.type == 'pdf' ? Icons.picture_as_pdf : Icons.description,
              color: color,
              size: 20.sp,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  document.name,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (document.description.isNotEmpty)
                  Text(
                    document.description,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textSecondary,
                    ),
                  ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => _downloadDocument(document),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(6.r),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.download,
                    color: AppColors.textOnPrimary,
                    size: 16.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'تحميل',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: AppColors.textOnPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalInfo(String info, Color color) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info,
                color: color,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'معلومات إضافية',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            info,
            style: TextStyle(
              fontSize: 13.sp,
              color: AppColors.textSecondary,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  void _downloadDocument(AdmissionDocument document) {
    // TODO: Implement actual download functionality
    Get.snackbar(
      'تحميل الملف',
      'سيتم تحميل ${document.name} قريباً',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: AppColors.primary,
      colorText: AppColors.textOnPrimary,
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
          
          ListView.builder(
            padding: EdgeInsets.only(top: 10.h),
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

  Widget _buildFacultyMembersSection(College college) {
    return Container(
      margin: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [college.primaryColor, college.secondaryColor],
                  ),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.people_alt,
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
                      'الكادر التدريسي',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      '${college.facultyMembers.length} عضو هيئة تدريس',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          
          // Faculty Members Grid
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: college.facultyMembers.length,
            itemBuilder: (context, index) {
              final facultyMember = college.facultyMembers[index];
              return FacultyMemberCard(
                facultyMember: facultyMember,
                primaryColor: college.primaryColor,
                animationDelay: index * 100,
              );
            },
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
