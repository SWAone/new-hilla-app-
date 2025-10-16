import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'app/controllers/college_controller.dart';
import 'app/controllers/news_controller.dart';
import 'app/controllers/events_controller.dart';
import 'app/views/main_view.dart';
import 'core/theme/app_theme.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'جامعة الحلة',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const MainView(),
          initialBinding: AppBinding(),
          defaultTransition: Transition.fade,
          transitionDuration: const Duration(milliseconds: 300),
        );
      },
    );
  }
}

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CollegeController>(CollegeController());
    Get.put<NewsController>(NewsController());
    Get.put<EventsController>(EventsController());
  }
}
