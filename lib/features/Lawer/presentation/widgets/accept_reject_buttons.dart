import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/features/lawer/data/models/case_status_enum.dart';
import 'package:nahkum/features/lawer/presentation/controllers/case_details_controller.dart';

class AcceptRejectButtons extends GetView<CaseDetailsController> {
  const AcceptRejectButtons({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (controller.caseRequestModel.status != CaseStatus.pending) {
      return SizedBox();
    }
    return Obx(() {
      if (controller.isAcceptRejectLoading.value) {
        return CircularProgressIndicator(color: AppColors.gold);
      }
      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () =>
                  controller.acceptRejectCaseRequest(isAccept: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "قبول القضية",
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          8.verticalSpace,
          SizedBox(
            width: double.infinity,
            height: 48,
            child: TextButton(
              onPressed: () =>
                  controller.acceptRejectCaseRequest(isAccept: false),
              child: Text(
                "رفض",
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
