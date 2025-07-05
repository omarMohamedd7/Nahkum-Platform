import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/widgets/custom_button.dart';
import 'package:nahkum/core/widgets/custom_text_field.dart';
import 'package:nahkum/features/profile/presentation/controller/profile_controller.dart';
import 'package:nahkum/features/profile/presentation/widgets/profile_image_widget.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(28.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 38.w,
                      height: 38.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                          ),
                          onPressed: () => Get.back(),
                        ),
                      ),
                    ),
                    const Text(
                      'الملف الشخصي',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF1B364B),
                      ),
                    ),
                    38.horizontalSpace,
                  ],
                ),
                50.verticalSpace,
                Obx(
                  () {
                    if (controller.isLoading.value) {
                      return Center(
                          child: Column(
                        children: [
                          0.3.sh.verticalSpace,
                          CircularProgressIndicator(),
                        ],
                      ));
                    }
                    return profileScreenBody();
                  },
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  Column profileScreenBody({bool isLoading = false}) {
    return Column(
      children: [
        ProfileImageWidget(),
        46.verticalSpace,
        CustomTextField(
          hintText: '',
          labelText: 'الاسم:',
          prefixIcon: Icons.person,
          controller: controller.nameController,
        ),
        46.verticalSpace,
        CustomTextField(
          hintText: '',
          labelText: 'البريد الإلكتروني:',
          prefixIcon: Icons.email,
          controller: controller.emailController,
        ),
        46.verticalSpace,
        if (!isLoading)
          Obx(
            () {
              return CustomButton(
                text: 'حفظ التعديلات',
                onTap: controller.editProfile,
                isLoading: controller.isEditLoading.value,
              );
            },
          ),
      ],
    );
  }
}
