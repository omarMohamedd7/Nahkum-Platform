import 'package:flutter/material.dart';
import 'package:nahkum/core/utils/app_colors.dart';
 
class ForgotPasswordLink extends StatelessWidget {
  final VoidCallback onTap;

  const ForgotPasswordLink({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(0, 36),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text(
          'هل نسيت كلمة المرور؟',
          style: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 15,
            fontWeight: FontWeight.bold,
            color: AppColors.goldLight,
          ),
        ),
      ),
    );
  }
}
