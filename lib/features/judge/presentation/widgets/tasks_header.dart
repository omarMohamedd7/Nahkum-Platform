import 'package:flutter/widgets.dart';
import 'package:nahkum/core/utils/app_colors.dart';

class TasksHeader extends StatelessWidget {
  const TasksHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Text(
          'عرض الكل',
          style: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: AppColors.gold,
          ),
        ),
        Text(
          'مهام اليوم',
          style: TextStyle(
            fontFamily: 'Almarai',
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
