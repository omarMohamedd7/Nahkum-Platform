import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/app_assets.dart';

class NotificationsButton extends StatelessWidget {
  const NotificationsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.NOTIFICATIONS),
      child: Container(
        padding: const EdgeInsets.all(8),
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 1, color: const Color(0xffBFBFBF))),
        child: SvgPicture.asset(
          height: 20,
          width: 20,
          AppAssets.notification,
        ),
      ),
    );
  }
}
