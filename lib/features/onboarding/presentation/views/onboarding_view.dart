import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/utils/app_assets.dart';
import '../controllers/onboarding_controller.dart';
import '../../data/models/user_role.dart';
import '../widgets/role_button.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: 1.sh,
            width: 1.sw,
            child: Image.asset(
              'assets/images/splash_screen.png',
              fit: BoxFit.fill,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                children: [
                  Spacer(),
                  _buildLogo(),
                  38.verticalSpace,
                  _buildTitleText(),
                  34.verticalSpace,
                  _buildRoleButtons(),
                  39.verticalSpace,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogo() {
    return Center(
      child: SizedBox(
        width: 175.w,
        height: 213.h,
        child: SvgPicture.asset(
          AppAssets.mainLogo,
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildTitleText() {
    return Text(
      'يرجى اختيار الصفة التي تمثل دورك\nفي التطبيق',
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      style: TextStyle(
        fontFamily: 'Almarai',
        fontSize: 22.sp,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      ),
    );
  }

  Widget _buildRoleButtons() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final role = UserRole.values[index];
        return Obx(
          () => RoleButton(
            role: role,
            isSelected: controller.selectedRole.value == role,
            onTap: () {
              controller.selectRole(role);
              Future.delayed(Duration(milliseconds: 350)).whenComplete(() {
                controller.navigateToLogin();
              });
            },
          ),
        );
      },
      separatorBuilder: (context, index) => 23.verticalSpace,
      itemCount: UserRole.values.length,
    );
  }
}
