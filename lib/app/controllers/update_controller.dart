import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import '../../data/api_client.dart';
import '../../models/update_info.dart';

class UpdateController extends GetxController {
  final ApiClient _api = ApiClient();

  final Rx<UpdateInfo?> updateInfo = Rx<UpdateInfo?>(null);
  final RxBool isLoading = false.obs;
  final RxBool needsUpdate = false.obs;
  final RxBool forceUpdate = false.obs;
  final RxString currentVersion = '1.0.0'.obs;

  @override
  void onInit() {
    super.onInit();
    _getCurrentVersion();
  }

  /// Get current app version from package info
  Future<void> _getCurrentVersion() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      currentVersion.value = packageInfo.version;
    } catch (e) {
      debugPrint('Error getting app version: $e');
    }
  }

  /// Compare two version strings
  /// Returns: -1 if version1 < version2, 0 if equal, 1 if version1 > version2
  int _compareVersions(String version1, String version2) {
    final v1Parts = version1.split('.').map((e) => int.tryParse(e) ?? 0).toList();
    final v2Parts = version2.split('.').map((e) => int.tryParse(e) ?? 0).toList();

    // Pad to same length
    while (v1Parts.length < v2Parts.length) v1Parts.add(0);
    while (v2Parts.length < v1Parts.length) v2Parts.add(0);

    for (int i = 0; i < v1Parts.length; i++) {
      if (v1Parts[i] < v2Parts[i]) return -1;
      if (v1Parts[i] > v2Parts[i]) return 1;
    }
    return 0;
  }

  /// Check if update is needed from API
  Future<bool> checkForUpdate() async {
    try {
      isLoading.value = true;
      needsUpdate.value = false;
      forceUpdate.value = false;

      // Get current version
      await _getCurrentVersion();

      // Fetch update info from API
      final response = await _api.get('/api/v1/app/update');
      final data = response['data'] as Map<String, dynamic>?;

      if (data != null) {
        updateInfo.value = UpdateInfo.fromJson(data);

        final info = updateInfo.value!;
        final current = currentVersion.value;

        // Check if current version is less than minimum version (force update)
        if (_compareVersions(current, info.minimumVersion) < 0) {
          forceUpdate.value = true;
          needsUpdate.value = true;
          return true;
        }

        // Check if current version is less than latest version (optional update)
        if (_compareVersions(current, info.latestVersion) < 0) {
          needsUpdate.value = true;
          // Check if force update flag is set
          if (info.forceUpdate) {
            forceUpdate.value = true;
          }
          return true;
        }
      }

      return false;
    } catch (e) {
      debugPrint('Error checking for update: $e');
      // On error, don't block the app
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  /// Get store link based on platform
  String getStoreLink() {
    final info = updateInfo.value;
    if (info == null) return '';

    if (Platform.isAndroid) {
      return info.androidStoreLink.isNotEmpty 
          ? info.androidStoreLink 
          : 'https://play.google.com/store/apps/details?id=com.example.hilla_medi_app';
    } else if (Platform.isIOS) {
      return info.iosStoreLink.isNotEmpty 
          ? info.iosStoreLink 
          : 'https://apps.apple.com/app/id1234567890';
    }

    return '';
  }

  @override
  void onClose() {
    _api.dispose();
    super.onClose();
  }
}

