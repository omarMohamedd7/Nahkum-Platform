import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/repo/auth_repo.dart';
import 'package:nahkum/core/routes/app_pages.dart';
import 'package:nahkum/core/utils/cache_helper.dart';

class OtpController extends GetxController {
  AuthRepo authRepo = AuthRepo();

  final otpFormKey = GlobalKey<FormState>();

  late List<TextEditingController> otpControllers;
  late List<FocusNode> otpFocusNodes;
  final remainingSeconds = 60.obs;
  Timer? _resendTimer;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    startOtpTimer();
    _initControllers();
  }

  void _initControllers() {
    otpControllers = List.generate(6, (_) => TextEditingController());
    otpFocusNodes = List.generate(6, (_) => FocusNode());
  }

  @override
  void onClose() {
    super.onClose();
    _disposeControllers();
    _resendTimer?.cancel();
  }

  void _disposeControllers() {
    for (var c in otpControllers) {
      c.dispose();
    }
    for (var f in otpFocusNodes) {
      f.dispose();
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    isLoading.value = true;

    final fcmToken = cache.read(CacheHelper.fcmToken);

    try {
      final result = await authRepo.verifyOtp(
        email: email,
        code: otp,
        fcmToken: fcmToken,
      );

      if (result is DataSuccess) {
        cache.write(CacheHelper.token, result.data!.token);
        cache.write(CacheHelper.user, result.data!.userModel.toJson());

        Get.offAllNamed(AppPages.homeRoute());
      } else if (result is DataFailed) {
        Get.snackbar(
          'خطأ',
          'رمز التحقق غير صحيح. يرجى المحاولة مرة أخرى.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء التحقق من الرمز. يرجى المحاولة مرة أخرى.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendOtpToEmail(String email) async {
    isLoading.value = true;

    final result = await authRepo.sendOtpToEmail(email: email);
    startOtpTimer();
    if (result is DataSuccess) {
      Get.snackbar('تم', 'تم إرسال رمز التحقق إلى بريدك الإلكتروني',
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

  void startOtpTimer() {
    remainingSeconds.value = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        timer.cancel();
      }
    });
  }
}
