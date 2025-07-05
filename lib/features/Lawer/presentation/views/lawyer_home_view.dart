import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/utils/cache_helper.dart';
import 'package:nahkum/core/widgets/home_profile_image.dart';
import 'package:nahkum/features/auth/data/models/models.dart';
import 'package:nahkum/features/lawer/data/models/case_request_model.dart';
import 'package:nahkum/features/lawer/data/models/case_status_enum.dart';
import 'package:nahkum/features/lawer/presentation/widgets/case_card.dart';
import 'package:nahkum/features/lawer/presentation/widgets/lawyer_app_bar_options.dart';
import '../controllers/home_controller.dart';
import '../widgets/lawyer_bottom_navigation_bar.dart';

class LawyerHomeView extends GetView<HomeController> {
  const LawyerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double padding = screenWidth < 360 ? 12 : 16;

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              44.verticalSpace,
              _buildAppBar(context),
              68.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: padding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildWelcomeSection(context),
                    SizedBox(height: screenWidth * 0.06),
                    _buildPowerOfAttorneyRequestsSection(context),
                    SizedBox(height: screenWidth * 0.06),
                    _buildPublishedCasesSection(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: LawyerBottomNavigationBar(
        key: const ValueKey('lawyer_home_view_bottom_nav'),
        currentIndex: 0,
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = screenWidth < 360 ? 13 : 14;
    final UserModel userModel =
        UserModel.fromJson(cache.read(CacheHelper.user));
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          LawyerAppBarOptions(),
          GestureDetector(
            onTap: () => Get.toNamed('/profile'),
            child: Row(
              children: [
                Text(
                  userModel.name,
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: fontSize,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF181E3C),
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                const HomeProfileImage(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double titleFontSize = screenWidth < 360 ? 22 : 24;
    final double textFontSize = screenWidth < 360 ? 13 : 14;
    final double logoWidth = screenWidth * 0.15;
    final double logoHeight = logoWidth * 1.24;

    return SizedBox(
      width: double.infinity,
      height: screenWidth * 0.42,
      child: Stack(
        children: [
          Image.asset('assets/images/slieder.png'),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05,
              vertical: screenWidth * 0.05,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF181E3C).withOpacity(0.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: screenWidth * 0.04),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'نحكم',
                        style: TextStyle(
                          fontFamily: 'Almarai',
                          fontSize: titleFontSize,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: screenWidth * 0.025),
                      Text(
                        'منصتك القانونية الموثوقة لربطك بمحامين مختصين وخدمات عدلية احترافية.',
                        style: TextStyle(
                          fontFamily: 'Almarai',
                          fontSize: textFontSize,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: screenWidth * 0.025),
                SvgPicture.asset(
                  'assets/images/main_logo.svg',
                  width: logoWidth,
                  height: logoHeight,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPowerOfAttorneyRequestsSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double titleFontSize = screenWidth < 360 ? 14 : 15;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => controller.navigateToAllAttorneyRequests(),
              child: Text(
                'عرض الكل',
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gold,
                ),
              ),
            ),
            Text(
              'طلبات توكيل مرسلة أليك',
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF181E3C),
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        SizedBox(height: screenWidth * 0.03),
        _buildAttorneyRequestCards(context),
      ],
    );
  }

  Widget _buildAttorneyRequestCards(BuildContext context) {
    return SizedBox(
      height: 209,
      child: Obx(() {
        if (controller.isCaseLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.caseRequests.isEmpty) {
          return const Center(child: Text('لا يوجد طلبات توكيل حالياً'));
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          reverse: true,
          itemCount: controller.caseRequests.length,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          itemBuilder: (context, index) {
            final request = controller.caseRequests[index];
            return Padding(
              padding: EdgeInsets.only(
                left: index == controller.caseRequests.length - 1 ? 0 : 8,
                right: index == 0 ? 0 : 8,
              ),
              child: CaseCard.fromAttorneyRequestModel(
                request,
                onTap: () {
                  Get.toNamed(Routes.LAWYER_CaseDetailsView, arguments: {
                    'case': request,
                    'isPublished': false,
                  });
                },
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildPublishedCasesSection(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double titleFontSize = screenWidth < 360 ? 14 : 15;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => controller.navigateToAllPublishedCases(),
              child: Text(
                'عرض الكل',
                style: TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.gold,
                ),
              ),
            ),
            Text(
              'قضايا منشورة من اختصاصك',
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: titleFontSize,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF181E3C),
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
        SizedBox(height: screenWidth * 0.03),
        _buildPublishedCaseCards(context),
        SizedBox(height: screenWidth * 0.06),
      ],
    );
  }

  Widget _buildPublishedCaseCards(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double cardHeight = screenWidth < 360 ? 210 : 220;

    return SizedBox(
      height: cardHeight,
      child: Obx(() {
        if (controller.isPublishedLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.publishedCases.isEmpty) {
          return const Center(child: Text('لا يوجد قضايا منشورة حالياً'));
        }

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          reverse: true,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          itemCount: controller.publishedCases.length,
          itemBuilder: (context, index) {
            final caseData = controller.publishedCases[index];
            return Padding(
              padding: EdgeInsets.only(
                left: index == controller.publishedCases.length - 1 ? 0 : 8,
                right: index == 0 ? 0 : 8,
              ),
              child: CaseCard.fromPublishedCaseModel(
                caseData,
                onTap: () {
                  Get.toNamed(Routes.LAWYER_CaseDetailsView, arguments: {
                    'case': CaseRequestModel(
                      requestId: caseData.publishedCaseId,
                      status: CaseStatus.parseCaseStatus(caseData.status),
                      caseDetails: caseData.caseDetails,
                      client: caseData.client,
                    ),
                    'hasOffered': caseData.hasOffered,
                    'isPublished': true,
                  });
                },
              ),
            );
          },
        );
      }),
    );
  }
}
