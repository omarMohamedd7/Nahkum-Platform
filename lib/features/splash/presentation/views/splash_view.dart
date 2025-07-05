import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/routes/app_pages.dart';
import 'package:nahkum/core/utils/app_assets.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  void _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 2));
    Get.offAllNamed(AppPages.getInitialRouteAfterSplash());
  }

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
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SvgPicture.asset(
                AppAssets.mainLogo,
                fit: BoxFit.contain,
                width: 193.w,
                height: 235.h,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
