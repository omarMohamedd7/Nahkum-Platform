import 'package:flutter/material.dart';
import 'package:nahkum/core/utils/app_colors.dart'; 

class TermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const TermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 24,
          width: 24,
          child: Checkbox(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.goldDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: RichText(
            textAlign: TextAlign.right,
            text: const TextSpan(
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: 14,
                color: AppColors.primary,
              ),
              children: [
                TextSpan(
                  text: 'من خلال تسجيل الدخول، فإنك توافق على ',
                ),
                TextSpan(
                  text: 'شروط الخدمة',
                  style: TextStyle(
                    color: AppColors.goldLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: ' و ',
                ),
                TextSpan(
                  text: 'اتفاقية معالجة البيانات',
                  style: TextStyle(
                    color: AppColors.goldLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
