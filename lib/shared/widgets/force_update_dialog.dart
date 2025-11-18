import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/controllers/update_controller.dart';
import '../../core/theme/app_colors.dart';

/// Dialog for forcing app update
class ForceUpdateDialog extends StatelessWidget {
  final bool isForceUpdate;
  final String? message;

  const ForceUpdateDialog({
    Key? key,
    required this.isForceUpdate,
    this.message,
  }) : super(key: key);

  Future<void> _openStore() async {
    final controller = Get.find<UpdateController>();
    final storeLink = controller.getStoreLink();

    if (storeLink.isNotEmpty) {
      final uri = Uri.parse(storeLink);
      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: Platform.isIOS
              ? LaunchMode.externalApplication
              : LaunchMode.externalApplication,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<UpdateController>();
    final updateInfo = controller.updateInfo.value;
    final currentVersion = controller.currentVersion.value;
    final latestVersion = updateInfo?.latestVersion ?? '1.0.0';

    return PopScope(
      canPop: !isForceUpdate, // Prevent back if force update
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Container(
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.primary,
                AppColors.primary.withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.system_update,
                  color: Colors.white,
                  size: 40.sp,
                ),
              ),
              SizedBox(height: 24.h),

              // Title
              Text(
                'تحديث مطلوب',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),

              // Message
              Text(
                message ??
                    updateInfo?.updateMessage ??
                    'يتوفر تحديث جديد للتطبيق. يرجى تحديث التطبيق لاستمرار الاستخدام.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 16.sp,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),

              // Version Info
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'الإصدار الحالي: ',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      currentVersion,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 16.sp,
                    ),
                    SizedBox(width: 16.w),
                    Text(
                      'الإصدار الجديد: ',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      latestVersion,
                      style: TextStyle(
                        color: Colors.yellow[300],
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              // Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _openStore,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: AppColors.primary,
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 4,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.download, size: 20.sp),
                      SizedBox(width: 8.w),
                      Text(
                        'تحديث الآن',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Cancel button (only if not force update)
              if (!isForceUpdate) ...[
                SizedBox(height: 12.h),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'لاحقاً',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

