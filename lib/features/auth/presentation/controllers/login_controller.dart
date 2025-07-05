import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/repo/auth_repo.dart';
import 'package:nahkum/core/routes/app_pages.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/cache_helper.dart';
import 'package:nahkum/features/onboarding/data/models/user_role.dart';
import 'package:nahkum/features/onboarding/presentation/controllers/onboarding_controller.dart';

class LoginController extends GetxController {
  AuthRepo authRepo = AuthRepo();

  final loginFormKey = GlobalKey<FormState>();

  late TextEditingController emailLoginController, passwordLoginController;

  final isLoading = false.obs;

  final acceptTerms = false.obs;

  final Rx<UserRole> userRole =
      Rx(Get.find<OnboardingController>().selectedRole.value!);

  Future<void> login() async {
    if (!loginFormKey.currentState!.validate() || !acceptTerms.value) return;
    isLoading.value = true;

    final fcmToken = cache.read(CacheHelper.fcmToken);

    final result = await authRepo.login(
      email: emailLoginController.text,
      password: passwordLoginController.text,
      fcmToken: fcmToken,
    );
    if (result is DataSuccess) {
      cache.write(CacheHelper.token, result.data!.token);
      cache.write(CacheHelper.user, result.data!.userModel.toJson());

      Get.offAllNamed(AppPages.homeRoute());
    } else if (result is DataFailed) {
      if (result.error!.statusCode == 403) {
        Get.snackbar(
          'تحقق من البريد الإلكتروني',
          'تم إرسال رمز التحقق إلى بريدك الإلكتروني',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );

        Get.toNamed(
          Routes.OTP_VERIFICATION,
          arguments: {'email': emailLoginController.text},
        );
      } else {
        Get.snackbar(
          'خطأ',
          result.error.toString(),
          backgroundColor: Colors.red,
        );
      }
    }
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    _initControllers();
  }

  void _initControllers() {
    emailLoginController = TextEditingController();
    passwordLoginController = TextEditingController();
  }

  @override
  void onClose() {
    super.onClose();
    _disposeControllers();
  }

  void _disposeControllers() {
    emailLoginController.dispose();
    passwordLoginController.dispose();
  }

  void setTermsAcceptance(bool value) {
    acceptTerms.value = value;
  }

  final googleIsLoading = false.obs;

  Future<void> signInWithGoogle() async {
    if (!acceptTerms.value) {
      Get.snackbar('تنبيه', 'يرجى الموافقة على الشروط والأحكام',
          backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    googleIsLoading.value = true;
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        googleIsLoading.value = false;
        return;
      }

      final email = googleUser.email;
      final name = googleUser.displayName ?? 'مستخدم Google';

      final fcmToken = cache.read(CacheHelper.fcmToken);

      final result = await authRepo.loginWithGoogle(
        email: email,
        name: name,
        fcmToken: fcmToken,
      );
      if (result is DataSuccess) {
        cache.write(CacheHelper.token, result.data!.token);
        cache.write(CacheHelper.user, result.data!.userModel.toJson());
        Get.offAllNamed(AppPages.homeRoute());
      } else if (result is DataFailed) {
        Get.snackbar(
          'خطأ',
          result.error.toString(),
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      Get.snackbar('خطأ', 'فشل تسجيل الدخول عبر Google: $e',
          backgroundColor: Colors.red);
    } finally {
      googleIsLoading.value = false;
    }
  }
}
