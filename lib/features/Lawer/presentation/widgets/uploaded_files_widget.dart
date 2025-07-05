import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/data/data_consts.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/features/lawer/presentation/controllers/case_details_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class UploadedFilesWidget extends GetView<CaseDetailsController> {
  const UploadedFilesWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (controller.files.isNotEmpty) {
          launch(DataConsts.imageBaseURL + controller.files.first);
        }
      },
      child: Container(
        height: 120.h,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFEF8F1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey, width: 0.5),
        ),
        child: Center(
          child: Obx(() {
            if (controller.isLoading.value) {
              return CircularProgressIndicator(
                color: AppColors.gold,
              );
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text(
                  'ملفات القضية',
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  'تم رفع ${controller.files.length} ملفات',
                  style: const TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 13,
                    color: AppColors.textPrimary,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: const Text(
                    'عرض الملفات',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 13,
                      color: AppColors.gold,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
