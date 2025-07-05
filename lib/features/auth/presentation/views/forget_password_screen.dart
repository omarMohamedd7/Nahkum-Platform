import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/utils/app_assets.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/utils/form_validator.dart';
import 'package:nahkum/core/widgets/custom_button.dart';
import 'package:nahkum/core/widgets/custom_text_field.dart';
import 'package:nahkum/features/auth/presentation/controllers/forget_password_controller.dart';

class ForgetPasswordScreen extends GetView<ForgetPasswordController> {
  const ForgetPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final bool isSmallScreen = screenSize.width < 600;

    return Scaffold(
      backgroundColor: AppColors.screenBackground,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: SvgPicture.asset(AppAssets.arrowRight,
                color: AppColors.primary),
            onPressed: () => Get.back(),
          ),
        ],
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
                  key: controller.forgotPasswordFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'هل نسيت كلمة المرور؟',
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
                        'يرجى إدخال بريدك الإلكتروني لإرسال رابط إعادة تعيين كلمة المرور',
                        style: TextStyle(
                          fontFamily: 'Almarai',
                          fontSize: 16,
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 48),
                      CustomTextField(
                        hintText: 'أدخل بريدك الإلكتروني',
                        labelText: 'البريد الإلكتروني',
                        iconPath: AppAssets.emailIcon,
                        controller: controller.emailForgotController,
                        keyboardType: TextInputType.emailAddress,
                        validator: FormValidators.validateEmail,
                      ),
                      const SizedBox(height: 32),
                      GetBuilder<ForgetPasswordController>(
                          builder: (controller) {
                        return SizedBox(
                          width: isSmallScreen
                              ? double.infinity
                              : screenSize.width * 0.5,
                          child: CustomButton(
                            text: 'إرسال',
                            onTap: controller.forgotPassword,
                            isLoading: controller.isLoading.value,
                            backgroundColor: AppColors.primary,
                            textColor: AppColors.white,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
