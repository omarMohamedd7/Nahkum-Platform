import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/utils/app_assets.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/utils/app_styles.dart';
import 'package:nahkum/features/lawer/data/models/case_request_model.dart';
import 'package:nahkum/features/lawer/data/models/case_status_enum.dart';
import 'package:nahkum/features/lawer/presentation/controllers/case_details_controller.dart';
import 'package:nahkum/features/lawer/presentation/widgets/accept_reject_buttons.dart';
import 'package:nahkum/features/lawer/presentation/widgets/make_offer_dialog.dart';
import 'package:nahkum/features/lawer/presentation/widgets/status_or_offer_box.dart';
import 'package:nahkum/features/lawer/presentation/widgets/uploaded_files_widget.dart';

class CaseDetailsView extends GetView<CaseDetailsController> {
  const CaseDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final CaseRequestModel caseRequestModel = controller.caseRequestModel;

    final clientName = caseRequestModel.client?.name;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'تفاصيل القضية',
            style: AppStyles.headingMedium,
          ),
          centerTitle: true,
          backgroundColor: AppColors.screenBackground,
          elevation: 0,
          leading: IconButton(
            icon: SvgPicture.asset(
              AppAssets.arrowRight,
              color: AppColors.primary,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        Text(
                          caseRequestModel.caseDetails.caseType,
                          style: const TextStyle(
                            fontFamily: 'Almarai',
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'رقم القضية: #${caseRequestModel.caseDetails.caseNumber}',
                          style: const TextStyle(
                            fontFamily: 'Almarai',
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                          textDirection: TextDirection.rtl,
                        ),
                        const SizedBox(height: 12),
                        StatusOrOfferBox(caseRequestModel: caseRequestModel),
                        const SizedBox(height: 56),
                        _infoRow(
                            'اسم الموكل', clientName ?? '', AppAssets.perso),
                        const SizedBox(height: 35),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'وصف القضية',
                            style: const TextStyle(
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Text(
                            caseRequestModel.caseDetails.description,
                            style: const TextStyle(
                              fontFamily: 'Almarai',
                              fontSize: 13,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        UploadedFilesWidget(),
                      ],
                    ),
                  ),
                ),
                if (!controller.isPublished) ...[
                  const AcceptRejectButtons(),
                ] else ...[
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!controller.hasOffered()) {
                          if (caseRequestModel.status == CaseStatus.pending) {
                            Get.dialog(
                              MakeOfferDialog(),
                              arguments: {
                                'case': controller.caseRequestModel,
                              },
                            );
                          } else {
                            //CHATTTTT
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: controller.hasOffered()
                            ? AppColors.primary.withAlpha(35)
                            : AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        controller.hasOffered()
                            ? 'بأنتظار موافقة الموكل'
                            : caseRequestModel.status == CaseStatus.pending
                                ? 'تقديم عرض للموكل'
                                : 'محادثة مع الموكل',
                        style: TextStyle(
                          fontFamily: 'Almarai',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value, String iconAsset) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Row(
              children: [
                SvgPicture.asset(iconAsset, width: 24, color: AppColors.gold),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'Almarai',
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
