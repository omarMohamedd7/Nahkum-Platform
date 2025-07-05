// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/utils/app_styles.dart';
import 'package:nahkum/core/utils/form_validator.dart';
import 'package:nahkum/core/widgets/custom_button.dart';
import 'package:nahkum/core/widgets/custom_text_field.dart';
import 'package:nahkum/features/auth/presentation/controllers/register_controller.dart';
import 'package:nahkum/features/onboarding/data/models/user_role.dart';
import '../widgets/terms_checkbox.dart';
import 'package:get/get.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        appBar:
            AppBar(backgroundColor: AppColors.screenBackground, elevation: 0),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 49, horizontal: 22),
                child: Form(
                  key: controller.registerFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          'إنشاء حساب جديد ${controller.userRole.value.getArabicName()}',
                          style: AppStyles.headingLarge.copyWith(
                            fontSize: 30,
                            fontWeight: FontWeight.w700,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          'للبدء، يرجى تعبئة البيانات التالية',
                          style: AppStyles.captionText.copyWith(
                            fontSize: 18,
                            letterSpacing: -0.5,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                      28.verticalSpace,
                      _buildFormFieldsColumn(controller.userRole.value),
                      53.verticalSpace,
                      Obx(() => TermsCheckbox(
                            value: controller.acceptTerms.value,
                            onChanged: (value) =>
                                controller.setTermsAcceptance(value ?? false),
                          )),
                      20.verticalSpace,
                      Obx(() => CustomButton(
                            text: 'إنشاء حساب',
                            onTap: controller.register,
                            isLoading: controller.isLoading.value,
                            backgroundColor: AppColors.primary,
                            textColor: AppColors.white,
                          )),
                      const SizedBox(height: 24),
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

  Widget _buildProfilePictureSection() {
    return Column(
      children: [
        Obx(() => GestureDetector(
              onTap: controller.showImageSourceDialog,
              child: Container(
                width: double.infinity,
                height: 86,
                decoration: BoxDecoration(
                  color: AppColors.goldLight.withOpacity(0.1),
                  borderRadius: AppStyles.radiusMedium,
                  border: Border.all(
                    color: AppColors.textSecondary,
                    width: 1,
                  ),
                  image: controller.selectedImage.value != null
                      ? DecorationImage(
                          image: FileImage(controller.selectedImage.value!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: controller.selectedImage.value == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/gallery.svg',
                            height: 24,
                            width: 24,
                            color: AppColors.primary,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'أضف صورتك الشخصية',
                            style: AppStyles.bodySmall,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      )
                    : null,
              ),
            )),
        Obx(() {
          if (controller.selectedImage.value != null) {
            return Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: TextButton(
                onPressed: controller.showImageSourceDialog,
                child: Text(
                  'تغيير الصورة',
                  style: TextStyle(
                    color: AppColors.goldDark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
      ],
    );
  }

  Widget _buildFormFieldsColumn(UserRole userRole) {
    return Column(
      children: [
        if (controller.userRole.value != UserRole.judge) ...[
          _buildProfilePictureSection(),
          34.verticalSpace,
        ],
        CustomTextField(
          hintText: 'أدخل أسم المستخدم',
          labelText: 'أسم المستخدم',
          iconPath: 'assets/images/user.svg',
          controller: controller.usernameController,
          validator: FormValidators.validateUsername,
        ),
        16.verticalSpace,
        CustomTextField(
          hintText: 'أدخل بريد الكتروني فعال',
          labelText: 'البريد الألكتروني',
          iconPath: 'assets/images/email_icon.svg',
          controller: controller.emailRegisterController,
          keyboardType: TextInputType.emailAddress,
          validator: FormValidators.validateEmail,
        ),
        16.verticalSpace,
        if (userRole == UserRole.client || userRole == UserRole.lawyer) ...[
          CustomTextField(
            hintText: 'أدخل رقم الهاتف الخاص بك',
            labelText: 'رقم الهاتف',
            iconPath: 'assets/images/mobile.svg',
            controller: controller.phoneController,
            keyboardType: TextInputType.phone,
            validator: FormValidators.validatePhone,
          ),
          16.verticalSpace,
          _buildCityDropdown(),
          16.verticalSpace,
        ],
        if (userRole != UserRole.client) ...[
          _buildSpecializationDropdown(),
          16.verticalSpace,
        ],
        if (userRole == UserRole.lawyer) ...[
          CustomTextField(
            hintText: 'أدخل رسوم الاستشارة',
            labelText: 'رسوم الاستشارة',
            iconPath: 'assets/images/money.svg',
            controller: controller.consultationFeeController,
            keyboardType: TextInputType.number,
            validator: (value) =>
                value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null,
          ),
          16.verticalSpace,
        ],
        if (userRole == UserRole.judge) ...[
          CustomTextField(
            hintText: 'أدخل اسم المحكمة',
            labelText: 'اسم المحكمة',
            iconPath: 'assets/images/unactive navbar/judge.svg',
            controller: controller.courtNameController,
            validator: (value) =>
                value?.isEmpty ?? true ? 'هذا الحقل مطلوب' : null,
          ),
          16.verticalSpace,
        ],
        CustomTextField(
          hintText: 'أدخل كلمة المرور الخاصة بك',
          labelText: 'كلمة المرور',
          iconPath: 'assets/images/lock_icon.svg',
          controller: controller.passwordRegisterController,
          isPassword: true,
          validator: FormValidators.validatePassword,
        ),
        16.verticalSpace,
        CustomTextField(
          hintText: 'أعد كتابة كلمة المرور للتأكيد',
          labelText: 'تأكيد كلمة المرور',
          iconPath: 'assets/images/lock_icon.svg',
          controller: controller.confirmPasswordController,
          isPassword: true,
          validator: (value) => FormValidators.validateConfirmPassword(
              value, controller.passwordRegisterController.text),
        ),
      ],
    );
  }

  Widget _buildCityDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'المدينة',
          style: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
            ),
          ),
          child: Obx(() => DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: controller.selectedCity.value.isNotEmpty
                      ? controller.selectedCity.value
                      : null,
                  hint: const Text(
                    'اختر المدينة',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 14,
                      color: Color(0xFFAAAAAA),
                    ),
                  ),
                  items: controller.cities.map((String city) {
                    return DropdownMenuItem<String>(
                      value: city,
                      child: Text(
                        city,
                        style: const TextStyle(
                          fontFamily: 'Almarai',
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    );
                  }).toList(),
                  onChanged: controller.setCity,
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: AppColors.primary),
                  elevation: 2,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontFamily: 'Almarai',
                  ),
                  dropdownColor: Colors.white,
                ),
              )),
        ),
      ],
    );
  }

  Widget _buildSpecializationDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'التخصص',
          style: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: const Color(0xFFE0E0E0),
            ),
          ),
          child: Obx(() => DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  value: controller.selectedSpecialization.value.isNotEmpty
                      ? controller.selectedSpecialization.value
                      : null,
                  hint: const Text(
                    'اختر التخصص',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 14,
                      color: Color(0xFFAAAAAA),
                    ),
                  ),
                  items:
                      controller.specializations.map((String specialization) {
                    return DropdownMenuItem<String>(
                      value: specialization,
                      child: Text(
                        specialization,
                        style: const TextStyle(
                          fontFamily: 'Almarai',
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    );
                  }).toList(),
                  onChanged: controller.setSpecialization,
                  icon: const Icon(Icons.keyboard_arrow_down,
                      color: AppColors.primary),
                  elevation: 2,
                  style: const TextStyle(
                    color: AppColors.primary,
                    fontFamily: 'Almarai',
                  ),
                  dropdownColor: Colors.white,
                ),
              )),
        ),
      ],
    );
  }
}
