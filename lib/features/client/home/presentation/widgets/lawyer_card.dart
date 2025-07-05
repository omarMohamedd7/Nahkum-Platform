import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/models/lawyer.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/app_assets.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/features/client/home/presentation/controllers/home_controller.dart';

class LawyerCard extends StatelessWidget {
  final Lawyer lawyer;
  final VoidCallback? onConsultTap;
  final VoidCallback? onRepresentTap;
  final bool fullWidth;

  const LawyerCard({
    super.key,
    required this.lawyer,
    this.onConsultTap,
    this.onRepresentTap,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final cardWidth = fullWidth ? double.infinity : screenWidth * 0.74;

    final double titleFontSize = screenWidth < 360 ? 13 : 15;
    final double bodyFontSize = screenWidth < 360 ? 11 : 13;
    final double smallFontSize = screenWidth < 360 ? 9 : 11;

    final double cardPadding = screenWidth < 360 ? 6 : 8;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: cardWidth,
      ),
      child: Container(
        width: cardWidth,
        margin:
            EdgeInsets.only(left: fullWidth ? 0 : 12, right: fullWidth ? 0 : 0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFBFBFBF),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: screenWidth < 360 ? 12 : 14,
                          color: Colors.grey,
                        ),
                        SizedBox(width: screenWidth < 360 ? 4 : 6),
                        Flexible(
                          child: Text(
                            lawyer.location,
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              fontSize: smallFontSize,
                              color: const Color(0xFF737373),
                            ),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                        ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    radius: screenWidth < 360 ? 18 : 22,
                    backgroundColor: Colors.grey[200],
                    child: SvgPicture.asset(
                      AppAssets.userProfileImage,
                      width: screenWidth < 360 ? 18 : 22,
                      height: screenWidth < 360 ? 18 : 22,
                      placeholderBuilder: (context) =>
                          const CircularProgressIndicator(),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: cardPadding, vertical: 2),
              child: Text(
                lawyer.name,
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: cardPadding, vertical: 2),
              child: Text(
                lawyer.description,
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: bodyFontSize,
                  color: const Color(0xFF737373),
                ),
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: screenWidth < 360 ? 2 : 4),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: cardPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth < 360 ? 6 : 8,
                            vertical: screenWidth < 360 ? 3 : 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${lawyer.consultationFee} \$',
                          style: TextStyle(
                            fontFamily: 'Almarai',
                            fontSize: smallFontSize,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      SizedBox(width: screenWidth < 360 ? 4 : 6),
                      Text(
                        'سعر الاستشارة:',
                        style: TextStyle(
                          fontFamily: 'Almarai',
                          fontSize: bodyFontSize,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenWidth < 360 ? 6 : 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth < 360 ? 6 : 8,
                            vertical: screenWidth < 360 ? 3 : 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryLight,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          lawyer.specialization,
                          style: TextStyle(
                            fontFamily: 'Almarai',
                            fontSize: smallFontSize,
                            color: AppColors.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: screenWidth < 360 ? 4 : 6),
                      Text(
                        'التخصص:',
                        style: TextStyle(
                          fontFamily: 'Almarai',
                          fontSize: bodyFontSize,
                          fontWeight: FontWeight.w500,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: screenWidth < 360 ? 8 : 10),
            Padding(
              padding: EdgeInsets.all(cardPadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onRepresentTap ??
                          () {
                            print(
                                'LawyerCard: Lawyer ID before processing: "${lawyer.id}", type: ${lawyer.id.runtimeType}');

                            // Use the helper method from Lawyer model
                            int lawyerId = lawyer.getIdAsInt();
                            print('LawyerCard: Parsed lawyer ID: $lawyerId');

                            // Use the HomeController to check for duplicate requests
                            final homeController = Get.find<HomeController>();
                            homeController.goToDirectCaseRequest(lawyer);
                          },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF181E3C),
                        backgroundColor: AppColors.primary,
                        side: const BorderSide(color: Color(0xFF181E3C)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth < 360 ? 2 : 4),
                        minimumSize: Size(0, screenWidth < 360 ? 28 : 30),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'طلب توكيل',
                          style: TextStyle(
                            fontFamily: 'Almarai',
                            fontSize: smallFontSize,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth < 360 ? 6 : 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onConsultTap ??
                          () {
                            Get.toNamed(
                              Routes.CONSULTATION_REQUEST,
                              arguments: lawyer,
                            );
                          },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                          side: BorderSide(color: AppColors.primary),
                        ),
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth < 360 ? 2 : 4),
                        minimumSize: Size(0, screenWidth < 360 ? 28 : 30),
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          'طلب استشارة',
                          style: TextStyle(
                            fontFamily: 'Almarai',
                            fontSize: smallFontSize,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
