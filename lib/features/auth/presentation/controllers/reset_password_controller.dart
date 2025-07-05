import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/repo/auth_repo.dart';
import 'package:nahkum/core/routes/app_routes.dart';

class ResetPasswordController extends GetxController {
  AuthRepo authRepo = AuthRepo();

  final resetPasswordFormKey = GlobalKey<FormState>();

  late TextEditingController newPasswordController,
      confirmNewPasswordController;

  final isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    _initControllers();
  }

  void _initControllers() {
    newPasswordController = TextEditingController();
    confirmNewPasswordController = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    _disposeControllers();
  }

  void _disposeControllers() {
    newPasswordController.dispose();
    confirmNewPasswordController.dispose();
  }

  Future<void> resetPassword(String email, String newPassword) async {
    if (!resetPasswordFormKey.currentState!.validate()) return;
    isLoading.value = true;

    final result =
        await authRepo.resetPassword(email: email, newPassword: newPassword);
    if (result is DataSuccess) {
      Get.offAllNamed(Routes.SPLASH);
    } else if (result is DataFailed) {
      Get.snackbar(
        'خطأ',
        result.error.toString(),
        backgroundColor: Colors.red,
      );
    }
    isLoading.value = false;
  }

  void showMessage(String message, {bool isError = false}) {
    Get.snackbar(
      isError ? 'خطأ' : 'نجاح',
      message,
      backgroundColor: isError ? Colors.red : Colors.green,
      colorText: Colors.white,
    );
  }
}
