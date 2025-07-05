import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/repo/auth_repo.dart';

class ForgetPasswordController extends GetxController {
  AuthRepo authRepo = AuthRepo();

  final forgotPasswordFormKey = GlobalKey<FormState>();

  late TextEditingController emailForgotController;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initControllers();
  }

  void _initControllers() {
    emailForgotController = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    _disposeControllers();
  }

  void _disposeControllers() {
    emailForgotController.dispose();
  }

  Future<void> forgotPassword() async {
    if (!forgotPasswordFormKey.currentState!.validate()) return;
    isLoading.value = true;

    final result = await authRepo.requestPasswordReset(
      email: emailForgotController.text,
    );

    if (result is DataSuccess) {
      Get.snackbar('تم', 'تم إرسال رابط إعادة التعيين',
          backgroundColor: Colors.green);
    } else if (result is DataFailed) {
      Get.snackbar(
        'خطأ',
        result.error.toString(),
        backgroundColor: Colors.red,
      );
    }
    isLoading.value = false;
  }
}
