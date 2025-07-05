import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/features/lawer/presentation/widgets/lawyer_app_bar_options.dart';

class LawyerAppBar extends StatelessWidget {
  const LawyerAppBar({
    super.key,
    required this.title,
  });

  final String title;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: AlignmentDirectional.centerStart,
            child: LawyerAppBarOptions(),
          ),
          8.horizontalSpace,
          Center(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
          ),
          8.horizontalSpace,
          0.22.sw.horizontalSpace,
        ],
      ),
    );
  }
}
