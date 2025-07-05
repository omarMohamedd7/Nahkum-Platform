// login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/app_assets.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/utils/app_styles.dart';
import 'package:nahkum/core/utils/form_validator.dart';
import 'package:nahkum/core/utils/responsive_utils.dart';
import 'package:nahkum/core/widgets/custom_button.dart';
import 'package:nahkum/core/widgets/custom_text_field.dart';
import 'package:nahkum/features/auth/presentation/controllers/login_controller.dart';
import '../widgets/forgot_password_link.dart';
import '../widgets/login_header.dart';
import '../widgets/sign_up_link.dart';
import '../widgets/terms_checkbox.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // controller.isLoading.value = false;
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: AppColors.screenBackground,
        elevation: 0,
        toolbarHeight: 0,
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: 1.sh - MediaQuery.of(context).padding.top,
              ),
              child: Padding(
                padding: AppStyles.horizontalPaddingLarge,
                child: Form(
                  key: controller.loginFormKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                          height:
                              ResponsiveUtils.getHeightPercentage(context, 2)),
                      const LoginHeader(compact: true),
                      SizedBox(
                          height:
                              ResponsiveUtils.getHeightPercentage(context, 3)),
                      Column(
                        children: [
                          CustomTextField(
                            hintText: 'أدخل بريد الكتروني فعال',
                            labelText: 'البريد الألكتروني',
                            iconPath: AppAssets.emailIcon,
                            controller: controller.emailLoginController,
                            keyboardType: TextInputType.emailAddress,
                            validator: FormValidators.validateEmail,
                          ),
                          SizedBox(
                              height: ResponsiveUtils.getHeightPercentage(
                                  context, 2)),
                          CustomTextField(
                            hintText: 'أدخل كلمة المرور الخاصة بك',
                            labelText: 'كلمة المرور',
                            iconPath: AppAssets.lock,
                            controller: controller.passwordLoginController,
                            isPassword: true,
                            validator: FormValidators.validatePassword,
                          ),
                          SizedBox(
                              height: ResponsiveUtils.getHeightPercentage(
                                  context, 1)),
                          ForgotPasswordLink(
                              onTap: () => Get.toNamed(Routes.FORGOT_PASSWORD)),
                        ],
                      ),
                      SizedBox(
                          height:
                              ResponsiveUtils.getHeightPercentage(context, 2)),
                      Obx(() => TermsCheckbox(
                            value: controller.acceptTerms.value,
                            onChanged: (value) {
                              controller.setTermsAcceptance(value ?? false);
                            },
                          )),
                      SizedBox(
                          height:
                              ResponsiveUtils.getHeightPercentage(context, 3)),
                      Column(
                        children: [
                          Obx(() => CustomButton(
                                text: 'تسجيل الدخول',
                                onTap: controller.login,
                                isLoading: controller.isLoading.value,
                                backgroundColor: AppColors.primary,
                                textColor: AppColors.white,
                                height:
                                    ResponsiveUtils.getButtonHeight(context),
                              )),
                          SizedBox(
                              height: ResponsiveUtils.getHeightPercentage(
                                  context, 2)),
                          Obx(() => CustomButton(
                                text: 'سجل باستخدام غوغل',
                                onTap: controller.signInWithGoogle,
                                isLoading: controller.googleIsLoading.value,
                                outlined: true,
                                backgroundColor: AppColors.white,
                                textColor: AppColors.primary,
                                leadingIconPath: AppAssets.google,
                                height:
                                    ResponsiveUtils.getButtonHeight(context),
                              )),
                          SizedBox(
                              height: ResponsiveUtils.getHeightPercentage(
                                  context, 2)),
                          SignUpLink(
                            onTap: () {
                              Get.toNamed(Routes.REGISTER, arguments: {
                                'role': controller.userRole,
                              });
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                          height:
                              ResponsiveUtils.getHeightPercentage(context, 2)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
