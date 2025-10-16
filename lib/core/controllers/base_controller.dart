import 'package:get/get.dart';

abstract class BaseController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool hasError = false.obs;

  void setLoading(bool loading) => isLoading.value = loading;
  
  void setError(String error) {
    errorMessage.value = error;
    hasError.value = true;
  }
  
  void clearError() {
    errorMessage.value = '';
    hasError.value = false;
  }
  
  void showErrorSnackBar(String message) {
    Get.snackbar(
      'خطأ',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.error,
      colorText: Get.theme.colorScheme.onError,
    );
  }
  
  void showSuccessSnackBar(String message) {
    Get.snackbar(
      'نجح',
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Get.theme.colorScheme.primary,
      colorText: Get.theme.colorScheme.onPrimary,
    );
  }
}

