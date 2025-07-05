import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nahkum/core/utils/app_assets.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/features/judge/data/models/task_model.dart';

class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
  });
  final TaskModel task;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Color(0xffd8d8d8)),
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                    backgroundColor: AppColors.gold.withAlpha(35),
                    child: SvgPicture.asset(AppAssets.judge)),
                14.horizontalSpace,
                Text(
                  'قضية رقم ${task.id}#',
                  style: const TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            10.verticalSpace,
            Divider(color: Color(0xffd8d8d8)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 20),
                    7.horizontalSpace,
                    Text(
                      'موعد المهمة',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Almarai',
                      ),
                    ),
                    8.horizontalSpace,
                    Text(
                      task.time,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Almarai',
                        color: Color(0xff767676),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Icons.date_range_outlined, size: 20),
                    7.horizontalSpace,
                    Text(
                      'تاريخ المهمة',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Almarai',
                      ),
                    ),
                    8.horizontalSpace,
                    Text(
                      task.date,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Almarai',
                        color: Color(0xff767676),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            16.verticalSpace,
            Text(
              task.title,
              style: const TextStyle(
                fontFamily: 'Almarai',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
            3.verticalSpace,
            Text(
              task.description,
              style: const TextStyle(
                fontFamily: 'Almarai',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
