import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/app_assets.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/features/lawer/data/models/case_request_model.dart';
import 'package:nahkum/features/lawer/data/models/case_status_enum.dart';
import 'package:nahkum/features/lawer/presentation/widgets/lawyer_app_bar.dart';
import '../widgets/lawyer_bottom_navigation_bar.dart';
import '../controllers/agencies_controller.dart';

class AgenciesView extends GetView<AgenciesController> {
  const AgenciesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              44.verticalSpace,
              LawyerAppBar(title: 'منشورات التوكيل'),
              const SizedBox(height: 24),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                        child:
                            CircularProgressIndicator(color: AppColors.gold));
                  }

                  return ListView.builder(
                    itemCount: controller.publishedCases.length,
                    itemBuilder: (context, index) {
                      final item = controller.publishedCases[index];
                      return _buildAgencyCard(
                        caseType: item.caseDetails.caseType,
                        city: item.client.city,
                        description: item.caseDetails.description,
                        onTap: () {
                          Get.toNamed(Routes.LAWYER_CaseDetailsView,
                              arguments: {
                                'case': CaseRequestModel(
                                  requestId: item.publishedCaseId,
                                  status:
                                      CaseStatus.parseCaseStatus(item.status),
                                  caseDetails: item.caseDetails,
                                  client: item.client,
                                ),
                                'hasOffered': item.hasOffered,
                                'isPublished': true,
                              });
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const LawyerBottomNavigationBar(
        currentIndex: 3,
      ),
    );
  }

  Widget _buildAgencyCard({
    required String caseType,
    required String city,
    required String description,
    required void Function()? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEEE3CD),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: SvgPicture.asset(
                      AppAssets.document,
                      color: AppColors.gold,
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      caseType,
                      style: const TextStyle(
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'المدينة: $city',
                      style: const TextStyle(
                        fontFamily: 'Almarai',
                        fontSize: 13,
                        color: Color(0xFF737373),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontFamily: 'Almarai',
                fontSize: 13,
                height: 1.4,
                color: Color(0xFF737373),
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 16),
            Center(
              child: IgnorePointer(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.gold,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(160, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'تقديم عرض',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
