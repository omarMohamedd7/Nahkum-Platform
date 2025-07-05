import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nahkum/core/utils/app_assets.dart';
import 'package:nahkum/core/utils/app_colors.dart'; 

class LoginHeader extends StatelessWidget {
  final bool compact;

  const LoginHeader({
    super.key,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgPicture.asset(
          color: AppColors.goldLight,
          AppAssets.mainLogo2,
          height: compact ? 90 : 100,
          width: compact ? 90 : 100,
        ),
        const SizedBox(height: 15),
        SizedBox(
          width: double.infinity,
          child: const Text(
            'نرحب بك في نحكم',
            style: TextStyle(
              fontFamily: 'Almarai',
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.right,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: Text(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            'الرجاء تسجيل الدخول للوصول إلى حسابك',
            style: TextStyle(
              height: 22 / 18,
              letterSpacing: 0,
              fontWeight: FontWeight.w400,
              fontFamily: 'Almarai',
              fontSize: 16,
              color: const Color(0xFF767676),
            ),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }
}
