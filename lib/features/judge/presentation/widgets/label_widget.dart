import 'package:flutter/material.dart';
import 'package:nahkum/core/utils/app_colors.dart';

class LabelWidget extends StatelessWidget {
  final String text;

  const LabelWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'Almarai',
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          fontSize: 13,
        ),
        textAlign: TextAlign.right,
      ),
    );
  }
}
