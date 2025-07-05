import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import '../../data/models/user_role.dart';

class OnboardingController extends GetxController {
  final Rx<UserRole?> selectedRole = Rx<UserRole?>(null);

  void selectRole(UserRole role) {
    selectedRole.value = role;
  }

  void navigateToLogin() {
    if (selectedRole.value != null) {
      Get.offAllNamed(Routes.LOGIN);
    } else {
      Get.snackbar(
        'تنبيه',
        'يرجى اختيار نوع الحساب',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
