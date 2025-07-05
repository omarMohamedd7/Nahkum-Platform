import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/app_colors.dart';

class SignUpLink extends StatelessWidget {
  final VoidCallback onTap;

  const SignUpLink({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'ليس لديك حساب؟',
          style: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 15,
            color: AppColors.primary,
          ),
        ),
        TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: GestureDetector(
            onTap: () => Get.toNamed(Routes.REGISTER),
            child: const Text(
              'قم بانشاء حساب',
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: AppColors.goldDark,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
