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
      if (sliderItems.isEmpty) {
        sliderItems.assignAll(_getDefaultSliders());
      }
      
    } catch (e) {
      debugPrint('Error fetching sliders: $e');
      // في حالة الخطأ، استخدم البيانات الافتراضية
      sliderItems.assignAll(_getDefaultSliders());
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
      buttonText: apiSlider.buttonText ?? 'اقرأ المزيد',
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

  List<SliderItem> _getDefaultSliders() {
    return [
      SliderItem(
        title: 'مرحباً بك في جامعة الحلة',
        description: 'جامعة عراقية رائدة في التعليم والبحث العلمي',
        icon: Icons.school_rounded,
        primaryColor: AppColors.primary,
        secondaryColor: AppColors.primaryLight,
        buttonText: 'استكشف الجامعة',
        imageUrl: 'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?w=800&h=600&fit=crop&auto=format',
      ),
      SliderItem(
        title: 'التعليم الرقمي',
        description: 'نوفر أحدث التقنيات في التعليم الإلكتروني',
        icon: Icons.computer_rounded,
        primaryColor: AppColors.secondary,
        secondaryColor: AppColors.secondaryLight,
        buttonText: 'تعلم الآن',
        imageUrl: 'https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=800&h=600&fit=crop&auto=format',
      ),
      SliderItem(
        title: 'البحث العلمي',
        description: 'مركز للابتكار والبحث في مختلف المجالات',
        icon: Icons.science_rounded,
        primaryColor: AppColors.accent,
        secondaryColor: AppColors.accentLight,
        buttonText: 'اكتشف المزيد',
        imageUrl: 'https://images.unsplash.com/photo-1532187863486-abf9dbad1b69?w=800&h=600&fit=crop&auto=format',
      ),
    ];
  }
}

