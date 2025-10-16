import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../app/controllers/events_controller.dart';
import '../../core/theme/app_colors.dart';
import '../../models/event_model.dart';
import '../../shared/widgets/animated_card.dart';
import 'event_detail_view.dart';

class EventsView extends StatelessWidget {
  const EventsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final EventsController controller = Get.find<EventsController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            _buildHeader(),
            
            // Tabs
            _buildTabs(controller),
            
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
                
                if (controller.filteredEvents.isEmpty) {
                  return _buildEmptyState();
                }
                
                return _buildEventsList(controller);
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          Container(
            width: 50.w,
            height: 50.w,
            decoration: BoxDecoration(
              gradient: AppColors.accentGradient,
              borderRadius: BorderRadius.circular(15.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accent.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.event_rounded,
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
                  'فعاليات الجامعة',
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'الفعاليات القادمة والجارية',
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

  Widget _buildTabs(EventsController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      child: Obx(() => Row(
        children: [
          Expanded(
            child: _buildTab(
              label: 'الكل',
              index: 0,
              isActive: controller.selectedTabIndex.value == 0,
              onTap: () => controller.setTabIndex(0),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _buildTab(
              label: 'قادمة',
              index: 1,
              isActive: controller.selectedTabIndex.value == 1,
              onTap: () => controller.setTabIndex(1),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _buildTab(
              label: 'جارية',
              index: 2,
              isActive: controller.selectedTabIndex.value == 2,
              onTap: () => controller.setTabIndex(2),
            ),
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: _buildTab(
              label: 'منتهية',
              index: 3,
              isActive: controller.selectedTabIndex.value == 3,
              onTap: () => controller.setTabIndex(3),
            ),
          ),
        ],
      )),
    );
  }

  Widget _buildTab({
    required String label,
    required int index,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          color: isActive ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isActive ? AppColors.accent : AppColors.textHint,
            width: 1,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? AppColors.textOnPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchAndFilter(EventsController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Column(
        children: [
          // Search Bar
          TextField(
            onChanged: controller.searchEvents,
            decoration: InputDecoration(
              hintText: 'البحث في الفعاليات...',
              prefixIcon: Icon(
                Icons.search,
                color: AppColors.textSecondary,
              ),
              suffixIcon: Obx(() => controller.isSearching.value
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: AppColors.textSecondary,
                      ),
                      onPressed: controller.clearSearch,
                    )
                  : const SizedBox.shrink()),
              filled: true,
              fillColor: AppColors.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.r),
                borderSide: BorderSide.none,
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 20.w,
                vertical: 16.h,
              ),
            ),
          ),
          
          SizedBox(height: 12.h),
          
          // Type Filter
          Obx(() => SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildTypeChip(
                  label: 'الكل',
                  isSelected: controller.selectedType.value == null,
                  onTap: () => controller.filterByType(null),
                ),
                SizedBox(width: 8.w),
                ...EventType.values.map((type) => 
                  Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: _buildTypeChip(
                      label: type.displayName,
                      isSelected: controller.selectedType.value == type,
                      onTap: () => controller.filterByType(type),
                    ),
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildTypeChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.textHint,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? AppColors.textOnPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.accent),
          ),
          SizedBox(height: 16.h),
          Text(
            'جاري تحميل الفعاليات...',
            style: TextStyle(
              fontSize: 16.sp,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(EventsController controller) {
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
            'حدث خطأ في تحميل الفعاليات',
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
            onPressed: controller.loadEvents,
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
            Icons.event_busy,
            size: 64.sp,
            color: AppColors.textHint,
          ),
          SizedBox(height: 16.h),
          Text(
            'لا توجد فعاليات',
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

  Widget _buildEventsList(EventsController controller) {
    return Obx(() => ListView.builder(
      padding: EdgeInsets.all(20.w),
      itemCount: controller.filteredEvents.length,
      itemBuilder: (context, index) {
        final event = controller.filteredEvents[index];
        return AnimatedCard(
          delay: index * 100,
          onTap: () => Get.to(
            () => EventDetailView(eventId: event.id),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status and type
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: event.categoryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      event.type.displayName,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: event.categoryColor,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: _getStatusColor(event.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      event.status.displayName,
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(event.status),
                      ),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 12.h),
              
              // Title
              Text(
                event.title,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                  height: 1.3,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(height: 8.h),
              
              // Description
              Text(
                event.description,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              SizedBox(height: 12.h),
              
              // Event Details
              Row(
                children: [
                  _buildEventDetail(
                    icon: Icons.calendar_today,
                    text: event.dateRange,
                    color: event.categoryColor,
                  ),
                  SizedBox(width: 16.w),
                  _buildEventDetail(
                    icon: Icons.access_time,
                    text: event.timeRange,
                    color: event.categoryColor,
                  ),
                ],
              ),
              
              SizedBox(height: 8.h),
              
              Row(
                children: [
                  _buildEventDetail(
                    icon: Icons.location_on,
                    text: event.location,
                    color: event.categoryColor,
                  ),
                  SizedBox(width: 16.w),
                  _buildEventDetail(
                    icon: Icons.business,
                    text: event.organizer,
                    color: event.categoryColor,
                  ),
                ],
              ),
              
              SizedBox(height: 12.h),
              
              // Footer
              Row(
                children: [
                  if (event.maxAttendees > 0) ...[
                    Icon(
                      Icons.people,
                      size: 14.sp,
                      color: AppColors.textHint,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${event.currentAttendees}/${event.maxAttendees}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(width: 16.w),
                  ],
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14.sp,
                    color: AppColors.textHint,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    ));
  }

  Widget _buildEventDetail({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            icon,
            size: 14.sp,
            color: color,
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(EventStatus status) {
    switch (status) {
      case EventStatus.upcoming:
        return AppColors.info;
      case EventStatus.ongoing:
        return AppColors.success;
      case EventStatus.completed:
        return AppColors.textSecondary;
    }
  }
}
