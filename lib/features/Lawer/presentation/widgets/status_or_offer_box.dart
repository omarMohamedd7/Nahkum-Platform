import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nahkum/core/utils/app_assets.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/utils/app_styles.dart';
import 'package:nahkum/features/lawer/data/models/case_request_model.dart';
import 'package:nahkum/features/lawer/data/models/case_status_enum.dart';

class StatusOrOfferBox extends StatelessWidget {
  const StatusOrOfferBox({
    super.key,
    required this.caseRequestModel,
  });

  final CaseRequestModel caseRequestModel;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      if (caseRequestModel.status == CaseStatus.pending) {
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.gold.withAlpha(15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              CircleAvatar(
                  backgroundColor: AppColors.gold.withAlpha(35),
                  child: SvgPicture.asset(AppAssets.lamp)),
              12.horizontalSpace,
              Expanded(
                child: Text(
                    'حدد أتعابك المتوقعة، وقدم وصفاً لما ستقوم به لمعالجة القضية، ثم انتظر موافقة الموكل على العرض.',
                    style: AppStyles.bodyMedium.copyWith(
                      fontSize: 14,
                    )),
              ),
            ],
          ),
        );
      }
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
        decoration: BoxDecoration(
          color: caseRequestModel.status.getStatusColor().withAlpha(45),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          caseRequestModel.status.getLocalizedStatus(),
          style: TextStyle(
            fontFamily: 'Almarai',
            color: caseRequestModel.status.getStatusColor(),
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    });
  }
}
