import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../app/controllers/events_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../models/event_model.dart';
import '../../shared/widgets/animated_card.dart';

class EventDetailView extends StatelessWidget {
  final String eventId;

  const EventDetailView({
    Key? key,
    required this.eventId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EventsController controller = Get.find<EventsController>();
    final event = controller.getEventById(eventId);

    if (event == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('خطأ'),
        ),
        body: Center(
          child: Text('الفعالية غير موجودة'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 250.h,
            pinned: true,
            backgroundColor: event.categoryColor,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                event.type.displayName,
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
                      event.categoryColor,
                      event.categoryColor.withOpacity(0.8),
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
                      _getEventIcon(event.type),
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
                  // Title and Status
                  _buildHeader(event),
                  
                  // Event Info
                  _buildEventInfo(event),
                  
                  // Speakers
                  if (event.speakers.isNotEmpty) _buildSpeakers(event),
                  
                  // Attendees Info
                  if (event.maxAttendees > 0) _buildAttendeesInfo(event),
                  
                  // Tags
                  _buildTags(event),
                  
                  // Contact Info
                  _buildContactInfo(event),
                  
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(event) {
    return AnimatedCard(
      delay: 0,
      margin: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Text(
            event.title,
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              height: 1.3,
            ),
          ),
          
          SizedBox(height: 16.h),
          
          // Status and Type
          Row(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: event.categoryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  event.type.displayName,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: event.categoryColor,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: _getStatusColor(event.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Text(
                  event.status.displayName,
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                    color: _getStatusColor(event.status),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventInfo(event) {
    return AnimatedCard(
      delay: 100,
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: event.categoryColor,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'معلومات الفعالية',
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
            event.description,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          SizedBox(height: 20.h),
          _buildInfoRow(
            icon: Icons.calendar_today,
            label: 'التاريخ',
            value: event.dateRange,
            color: event.categoryColor,
          ),
          SizedBox(height: 12.h),
          _buildInfoRow(
            icon: Icons.access_time,
            label: 'الوقت',
            value: event.timeRange,
            color: event.categoryColor,
          ),
          SizedBox(height: 12.h),
          _buildInfoRow(
            icon: Icons.location_on,
            label: 'المكان',
            value: event.location,
            color: event.categoryColor,
          ),
          SizedBox(height: 12.h),
          _buildInfoRow(
            icon: Icons.business,
            label: 'الجهة المنظمة',
            value: event.organizer,
            color: event.categoryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40.w,
          height: 40.w,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            icon,
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
                label,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 2.h),
              Text(
                value,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSpeakers(event) {
    return AnimatedCard(
      delay: 200,
      margin: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.person,
                color: event.categoryColor,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'المتحدثون',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          ...event.speakers.map((speaker) => Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    color: event.categoryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(
                    Icons.person,
                    color: event.categoryColor,
                    size: 16.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Text(
                  speaker,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildAttendeesInfo(event) {
    return AnimatedCard(
      delay: 300,
      margin: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.people,
                color: event.categoryColor,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'المشاركون',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildAttendeeCard(
                  label: 'مسجلون',
                  count: event.currentAttendees,
                  color: event.categoryColor,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _buildAttendeeCard(
                  label: 'الحد الأقصى',
                  count: event.maxAttendees,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendeeCard({
    required String label,
    required int count,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTags(event) {
    return AnimatedCard(
      delay: 400,
      margin: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.tag,
                color: event.categoryColor,
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
            children: event.tags.map((tag) => Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
              decoration: BoxDecoration(
                color: event.categoryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color: event.categoryColor.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: event.categoryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(event) {
    return AnimatedCard(
      delay: 500,
      margin: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.contact_phone,
                color: event.categoryColor,
                size: 24.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'معلومات التواصل',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: event.categoryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              event.contactInfo,
              style: TextStyle(
                fontSize: 14.sp,
                color: event.categoryColor,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  IconData _getEventIcon(eventType) {
    switch (eventType.toString()) {
      case 'EventType.conference':
        return Icons.people;
      case 'EventType.workshop':
        return Icons.work;
      case 'EventType.seminar':
        return Icons.school;
      case 'EventType.cultural':
        return Icons.palette;
      case 'EventType.sports':
        return Icons.sports;
      case 'EventType.academic':
        return Icons.science;
      case 'EventType.graduation':
        return Icons.school;
      case 'EventType.ceremony':
        return Icons.celebration;
      default:
        return Icons.event;
    }
  }

  Color _getStatusColor(status) {
    switch (status.toString()) {
      case 'EventStatus.upcoming':
        return AppColors.info;
      case 'EventStatus.ongoing':
        return AppColors.success;
      case 'EventStatus.completed':
        return AppColors.textSecondary;
      default:
        return AppColors.textSecondary;
    }
  }
}
