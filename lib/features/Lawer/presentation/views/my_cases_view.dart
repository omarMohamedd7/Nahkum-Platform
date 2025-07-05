import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/app_assets.dart';
import 'package:nahkum/features/lawer/data/models/case_model.dart';
import 'package:nahkum/features/lawer/data/models/case_request_model.dart';
import 'package:nahkum/features/lawer/data/models/case_status_enum.dart';
import 'package:nahkum/features/lawer/presentation/widgets/lawyer_app_bar.dart';
import '../controllers/my_cases_controller.dart';
import '../widgets/lawyer_bottom_navigation_bar.dart';

class MyCasesView extends GetView<MyCasesController> {
  const MyCasesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Column(
          children: [
            44.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LawyerAppBar(title: 'قضاياي'),
            ),
            20.verticalSpace,
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: const Color(0xFFBFBFBF),
                  width: 1,
                ),
              ),
              child: TabBar(
                dividerColor: Colors.transparent,
                controller: controller.tabController,
                indicator: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: const Color(0xFFC8A45D),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: const Color(0xFFBFBFBF),
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Almarai',
                ),
                tabs: const [
                  Tab(text: 'القضايا المغلقة'),
                  Tab(text: 'القضايا النشطة'),
                ],
              ),
            ),

            // Cases
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                children: [
                  _buildCasesListView(controller.closedCases),
                  _buildCasesListView(controller.activeCases),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const LawyerBottomNavigationBar(currentIndex: 2),
    );
  }

  Widget _buildCasesListView(RxList<CaseModel> cases) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(
          child: CircularProgressIndicator(color: Color(0xFFC8A45D)),
        );
      }

      if (controller.hasError.value) {
        return Center(
          child: Text(
            controller.errorMessage.value,
            style: const TextStyle(color: Colors.red, fontFamily: 'Almarai'),
          ),
        );
      }

      if (cases.isEmpty) {
        return const Center(
          child: Text(
            'لا توجد قضايا',
            style: TextStyle(color: Color(0xFF737373), fontFamily: 'Almarai'),
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        itemCount: cases.length,
        itemBuilder: (context, index) {
          final caseItem = cases[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: _buildCaseCard(caseItem, context),
          );
        },
      );
    });
  }

  Widget _buildCaseCard(CaseModel caseItem, BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final bool isActive = caseItem.status == 'active';

    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.LAWYER_CaseDetailsView, arguments: {
          'case': CaseRequestModel(
            requestId: caseItem.caseId,
            status: isActive ? CaseStatus.accepted : CaseStatus.rejected,
            caseDetails: caseItem,
            client: caseItem.client,
          ),
          'isPublished': false,
        });
      },
      child: Container(
        width: screenWidth - 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFBFBFBF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0x330BB435)
                          : const Color(0x33D30004),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Text(
                      caseItem.status == 'active' ? 'نشطة' : "مغلقة",
                      style: TextStyle(
                        color: isActive
                            ? const Color(
                                0xFF0BB435) // Green text for active cases
                            : const Color(
                                0xFFD30004), // Red text for closed cases
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Almarai',
                      ),
                    ),
                  ),

                  const Spacer(),

                  // Case information (center)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        caseItem.caseType,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Almarai',
                          color: Color(0xFF181E3C),
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'اسم الموكل: ${caseItem.clientName}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontFamily: 'Almarai',
                          color: Color(0xFF737373),
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'رقم القضية: ${caseItem.caseNumber}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontFamily: 'Almarai',
                          color: Color(0xFF737373),
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),

                  const SizedBox(width: 12),

                  // Case icon (right side in RTL)
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEEE3CD),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.gavel,
                        color: Color(0xFFC8A45D),
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Divider(color: Color(0xFFD8D8D8), height: 1),

            // Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                caseItem.description,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF737373),
                  fontFamily: 'Almarai',
                  height: 1.4,
                ),
                textAlign: TextAlign.right,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            // تفاصيل
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
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
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF181E3C),
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
