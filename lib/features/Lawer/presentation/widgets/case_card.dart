import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/app_assets.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/features/lawer/data/models/case_request_model.dart';
import 'package:nahkum/features/lawer/data/models/case_status_enum.dart';
import 'package:nahkum/features/lawer/data/models/published_case_model.dart';

class CaseCard extends StatelessWidget {
  final String caseType;
  final String clientName;
  final CaseStatus caseStatus;
  final String caseNumber;
  final String? description;
  final String? date;
  final String? city;
  final bool isAttorneyRequest;
  final bool isPublishedCase;
  final VoidCallback onTap;

  const CaseCard({
    super.key,
    required this.caseType,
    required this.clientName,
    required this.caseStatus,
    required this.caseNumber,
    this.description,
    this.date,
    this.city,
    this.isAttorneyRequest = false,
    this.isPublishedCase = false,
    required this.onTap,
  });

  factory CaseCard.fromAttorneyRequestModel(
    CaseRequestModel request, {
    required VoidCallback onTap,
  }) {
    return CaseCard(
      caseType: request.caseDetails.caseType,
      clientName: request.client?.name ?? '',
      caseStatus: request.status,
      caseNumber: request.caseDetails.caseNumber,
      description: request.caseDetails.description,
      isAttorneyRequest: true,
      onTap: onTap,
    );
  }

  factory CaseCard.fromPublishedCaseModel(
    PublishedCaseModel publishedCase, {
    required VoidCallback onTap,
  }) {
    return CaseCard(
      caseType: publishedCase.caseDetails.caseType,
      clientName: publishedCase.client.name,
      caseStatus: CaseStatus.pending,
      caseNumber: '# ${publishedCase.caseDetails.caseNumber.toString()}',
      description: publishedCase.caseDetails.description,
      city: publishedCase.client.city,
      isPublishedCase: true,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final cardWidth =
        screenWidth < 360 ? screenWidth * 0.68 : screenWidth * 0.53;
    final double fontSize = screenWidth < 360 ? 12 : 14;
    final double smallFontSize = screenWidth < 360 ? 9 : 10;
    final double containerPadding = screenWidth < 360 ? 6 : 10;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 209,
        width: cardWidth,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFBFBFBF)),
        ),
        child: Padding(
          padding: EdgeInsets.all(containerPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          caseType,
                          style: TextStyle(
                            fontFamily: 'Almarai',
                            fontSize: fontSize,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF181E3C),
                          ),
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        6.verticalSpace,
                        Text(
                          isPublishedCase
                              ? 'المدينة: ${city ?? "غير محدد"}'
                              : 'اسم الموكل: $clientName',
                          style: TextStyle(
                            fontFamily: 'Almarai',
                            fontSize: smallFontSize,
                            color: const Color(0xFF181E3C),
                          ),
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: screenWidth < 360 ? 2 : 4),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              caseStatus.getLocalizedStatus(),
                              style: TextStyle(
                                fontFamily: 'Almarai',
                                fontSize: smallFontSize,
                                fontWeight: FontWeight.bold,
                                color: caseStatus.getStatusColor(),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              ' :حالة القضية',
                              style: TextStyle(
                                fontFamily: 'Almarai',
                                fontSize: smallFontSize,
                                color: const Color(0xFF181E3C),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenWidth < 360 ? 2 : 4),
                        Text(
                          'رقم القضية: $caseNumber',
                          style: TextStyle(
                            fontFamily: 'Almarai',
                            fontSize: smallFontSize,
                            color: const Color(0xFF181E3C),
                          ),
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  8.horizontalSpace,
                  Container(
                    padding: EdgeInsets.all(7.w),
                    decoration: const BoxDecoration(
                      color: Color(0xFFEEE3CD),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        'assets/images/noun-law.svg',
                        width: 24.w,
                        height: 24.w,
                        color: AppColors.gold,
                      ),
                    ),
                  ),
                ],
              ),
              12.verticalSpace,
              const Divider(color: Color(0xFFD8D8D8), height: 1),
              12.verticalSpace,
              if (description != null) ...[
                Text(
                  description!,
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 11,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF737373),
                    // height: 1.2,
                  ),
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
              SizedBox(height: screenWidth < 360 ? 3 : 6),
              if (isPublishedCase)
                Center(
                  child: IgnorePointer(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed(Routes.LAWYER_SUBMIT_OFFER, arguments: {
                          'caseType': caseType,
                          'city': city ?? '',
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        foregroundColor: Colors.white,
                        minimumSize: Size(screenWidth < 360 ? 120 : 140,
                            screenWidth < 360 ? 32 : 36),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'تقديم عرض',
                        style: TextStyle(
                          fontFamily: 'Almarai',
                          fontSize: screenWidth < 360 ? 12 : 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              else
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (date != null)
                      Row(
                        children: [
                          Text(
                            date!,
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              fontSize: smallFontSize,
                              color: const Color(0xFF737373),
                            ),
                          ),
                          const SizedBox(width: 4),
                          SvgPicture.asset(
                            'assets/images/lawyer home/calendar.svg',
                            width: screenWidth < 360 ? 12 : 14,
                            height: screenWidth < 360 ? 12 : 14,
                            color: const Color(0xFF181E3C),
                          ),
                        ],
                      ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Transform.flip(
                            flipX: true,
                            child: SvgPicture.asset(AppAssets.arrowRight)),
                        const SizedBox(width: 2),
                        Text(
                          'تفاصيل',
                          style: TextStyle(
                            fontFamily: 'Almarai',
                            fontSize: smallFontSize,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF181E3C),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
