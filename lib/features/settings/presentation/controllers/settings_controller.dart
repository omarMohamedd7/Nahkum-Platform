import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/cache_helper.dart';
import 'package:nahkum/features/onboarding/data/models/user_role.dart';
import 'package:nahkum/features/settings/presentation/views/about_screen.dart';
import 'package:nahkum/features/settings/presentation/views/privacy_screen.dart';

class SettingsController extends GetxController {
  final RxBool notificationsEnabled = true.obs;

  @override
  void onInit() {
    notificationsEnabled.value =
        cache.read(CacheHelper.notificationsEnabled) ?? true;
    super.onInit();
  }

  final UserRole userRole = Get.arguments['userRole'];

  void navigateToProfile() {
    Get.toNamed(Routes.PROFILE)!.whenComplete(() {
      update();
    });
  }

  void toggleNotifications() {
    notificationsEnabled.value = !notificationsEnabled.value;

    if (notificationsEnabled.value) {
      cache.write(CacheHelper.notificationsEnabled, notificationsEnabled.value);
    }
    Get.snackbar(
      'الإشعارات',
      notificationsEnabled.value ? 'تم تفعيل الإشعارات' : 'تم إيقاف الإشعارات',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void navigateToPrivacyPolicy() {
    Get.to(() => PrivacyScreen());
  }

  void navigateToAboutApp() {
    Get.to(() => AboutScreen());
  }

  void showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text(
          'تسجيل الخروج',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Almarai',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Almarai',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text(
              'إلغاء',
              style: TextStyle(
                fontFamily: 'Almarai',
                color: Colors.grey,
              ),
            ),
          ),
          TextButton(
            onPressed: logout,
            child: const Text(
              'تسجيل الخروج',
              style: TextStyle(
                fontFamily: 'Almarai',
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void logout() {
    CacheHelper.logout();
    Get.offAllNamed(Routes.SPLASH);
  }
}
