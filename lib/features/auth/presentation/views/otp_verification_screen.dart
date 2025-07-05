import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/widgets/custom_button.dart';
import 'package:nahkum/features/auth/presentation/controllers/otp_controller.dart';
import 'package:nahkum/features/auth/presentation/widgets/build_otp.dart';

class OtpVerificationScreen extends GetView<OtpController> {
  final String email;

  const OtpVerificationScreen({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    return WillPopScope(
      onWillPop: () async {
        final result = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('تأكيد الخروج'),
            content: const Text(
                'هل أنت متأكد من أنك تريد العودة؟ سيتعين عليك إعادة عملية التحقق.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('إلغاء'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('تأكيد'),
              ),
            ],
          ),
        );
        return result ?? false;
      },
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.screenBackground,
          elevation: 0,
        ),
        body: SafeArea(
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final horizontalPadding = isSmallScreen ? 24.0 : 80.0;
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    20,
                    horizontalPadding,
                    MediaQuery.of(context).viewInsets.bottom + 20,
                  ),
                  child: Form(
                    key: controller.otpFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'التحقق من الرمز',
                          style: TextStyle(
                            fontFamily: 'Almarai',
                            fontSize: isSmallScreen ? 24 : 30,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'أدخل رمز التفعيل المكوّن من 6 خانات المُرسل إلى بريدك $email',
                          style: TextStyle(
                            fontFamily: 'Almarai',
                            fontSize: isSmallScreen ? 16 : 18,
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 48),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: List.generate(
                              6,
                              (index) => OtpTextField(
                                controller: controller.otpControllers[index],
                                focusNode: controller.otpFocusNodes[index],
                                nextFocusNode: index < 5
                                    ? controller.otpFocusNodes[index + 1]
                                    : null,
                                previousFocusNode: index > 0
                                    ? controller.otpFocusNodes[index - 1]
                                    : null,
                                index: index,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        Obx(() => Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('لم تتلق الرمز؟',
                                    style: TextStyle(
                                        fontFamily: 'Almarai',
                                        fontSize: 16,
                                        color: AppColors.textSecondary)),
                                const SizedBox(width: 8),
                                TextButton(
                                  onPressed:
                                      controller.remainingSeconds.value == 0
                                          ? () =>
                                              controller.sendOtpToEmail(email)
                                          : null,
                                  child: Text(
                                    controller.remainingSeconds > 0
                                        ? 'إعادة الإرسال خلال $formattedTime'
                                        : 'إعادة الإرسال',
                                    style: TextStyle(
                                      fontFamily: 'Almarai',
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color:
                                          controller.remainingSeconds.value == 0
                                              ? AppColors.primary
                                              : AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        const SizedBox(height: 32),
                        Obx(() => SizedBox(
                              width: isSmallScreen
                                  ? double.infinity
                                  : screenSize.width * 0.5,
                              child: CustomButton(
                                text: 'تأكيد',
                                onTap: () =>
                                    controller.verifyOtp(email, getOtpString),
                                isLoading: controller.isLoading.value,
                                backgroundColor: AppColors.primary,
                                textColor: AppColors.white,
                              ),
                            )),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String get formattedTime {
    int minutes = controller.remainingSeconds ~/ 60;
    int seconds = (controller.remainingSeconds % 60).toInt();
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  String get getOtpString =>
      controller.otpControllers.map((c) => c.text).join();
}
