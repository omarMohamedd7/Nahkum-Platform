import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/utils/app_assets.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/utils/app_styles.dart';
import 'package:nahkum/features/client/home/presentation/widgets/bottom_navigation_bar.dart';
import 'package:nahkum/features/judge/presentation/widgets/custom_bottom_navigation_judge_bar.dart';
import 'package:nahkum/features/onboarding/data/models/user_role.dart';
import 'package:nahkum/features/settings/presentation/controllers/settings_controller.dart';
import 'package:nahkum/features/settings/presentation/widgets/custom_toggle_switch.dart';
import 'package:nahkum/features/settings/presentation/widgets/settings_item.dart';
import 'package:nahkum/features/settings/presentation/widgets/user_profile_card.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'الإعدادات',
          style: AppStyles.headingMedium,
        ),
        centerTitle: true,
        backgroundColor: AppColors.screenBackground,
        elevation: 0,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              AppAssets.arrowRight,
              color: AppColors.primary,
            ),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GetBuilder<SettingsController>(builder: (controller) {
                return UserProfileCard(
                  onTap: controller.navigateToProfile,
                );
              }),
              Expanded(
                child: ListView(
                  children: [
                    Obx(() => SettingsItem(
                          title: 'الإشعارات',
                          iconPath: 'assets/images/notification.svg',
                          onTap: controller.toggleNotifications,
                          trailing: CustomToggleSwitch(
                            value: controller.notificationsEnabled.value,
                            onChanged: (value) =>
                                controller.toggleNotifications(),
                          ),
                        )),
                    SettingsItem(
                      title: 'سياسة الخصوصية',
                      iconPath: 'assets/images/security.svg',
                      onTap: controller.navigateToPrivacyPolicy,
                    ),
                    SettingsItem(
                      title: 'حول التطبيق',
                      iconPath: 'assets/images/info-circle.svg',
                      onTap: controller.navigateToAboutApp,
                    ),
                    SettingsItem(
                      title: 'تسجيل الخروج',
                      iconPath: 'assets/images/logout.svg',
                      onTap: controller.showLogoutDialog,
                      iconColor: const Color(0xFFC8A45D),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: controller.userRole == UserRole.client
          ? CustomBottomNavigationBar(
              key: const ValueKey('settings_view_bottom_nav'),
              currentIndex: 4,
            )
          : controller.userRole == UserRole.judge
              ? CustomBottomNavigationJudgeBar(
                  key: const ValueKey('settings_view_bottom_nav'),
                  currentIndex: 4,
                )
              : null,
    );
  }
}
