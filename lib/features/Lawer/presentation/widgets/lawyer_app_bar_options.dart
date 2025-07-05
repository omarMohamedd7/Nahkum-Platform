import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/app_assets.dart';
import 'package:nahkum/features/onboarding/data/models/user_role.dart';

class LawyerAppBarOptions extends StatelessWidget {
  const LawyerAppBarOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        option(svg: AppAssets.notification, route: Routes.NOTIFICATIONS),
        8.horizontalSpace,
        option(svg: AppAssets.unactiveMessage, route: Routes.CHATS),
        8.horizontalSpace,
        option(
          svg: AppAssets.unactiveSetting,
          route: Routes.SETTINGS,
          arguments: {'userRole': UserRole.lawyer},
        ),
      ],
    );
  }

  Widget option({
    required String svg,
    required String route,
    Map<String, dynamic>? arguments,
  }) {
    return GestureDetector(
      onTap: () => Get.toNamed(route, arguments: arguments),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: const Color(0xffBFBFBF))),
        child: SvgPicture.asset(
          height: 20,
          width: 20,
          svg,
        ),
      ),
    );
  }
}
