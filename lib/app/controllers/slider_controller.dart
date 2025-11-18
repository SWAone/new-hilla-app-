import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/controllers/base_controller.dart';
import '../../models/slider_api.dart';
import '../../data/sliders_repository.dart';
import '../../shared/widgets/hero_slider.dart';
import '../../core/theme/app_colors.dart';

class SliderController extends BaseController {
  final RxList<SliderItem> sliderItems = <SliderItem>[].obs;

  final SlidersRepository _repository = SlidersRepository();

  @override
  void onInit() {
    super.onInit();
    loadSliders();
  }

  Future<void> loadSliders() async {
    try {
      setLoading(true);
      clearError();
      
      final sliders = await _repository.fetchActiveSliders();
      
      sliderItems.assignAll(sliders.map(_convertToSliderItem).toList());
      
      // إذا لم توجد سلايدرات، استخدم البيانات الافتراضية
      // if (sliderItems.isEmpty) {
      //   sliderItems.assignAll(_getDefaultSliders());
      // }
      
    } catch (e) {
      debugPrint('Error fetching sliders: $e');
      // في حالة الخطأ، استخدم البيانات الافتراضية
      // sliderItems.assignAll(_getDefaultSliders());
    } finally {
      setLoading(false);
    }
  }

  SliderItem _convertToSliderItem(SliderApi apiSlider) {
    return SliderItem(
      title: apiSlider.title,
      description: apiSlider.description,
      icon: IconHelper.getIconData(apiSlider.icon),
      primaryColor: _parseColor(apiSlider.primaryColor),
      secondaryColor: _parseColor(apiSlider.secondaryColor),
      buttonText: apiSlider.buttonText ?? '',
      imageUrl: apiSlider.imageUrl,
      onTap: apiSlider.buttonLink != null && apiSlider.buttonLink!.isNotEmpty
          ? () {
              // يمكن إضافة navigation هنا إذا لزم الأمر
              debugPrint('Navigate to: ${apiSlider.buttonLink}');
            }
          : null,
    );
  }

  Color _parseColor(String colorHex) {
    try {
      // إزالة # إذا كانت موجودة
      final hex = colorHex.replaceAll('#', '');
      // تحويل من hex string إلى int ثم إلى Color
      return Color(int.parse('FF$hex', radix: 16));
    } catch (e) {
      debugPrint('Error parsing color: $colorHex, error: $e');
      return AppColors.primary; // لون افتراضي
    }
  }

 
}

