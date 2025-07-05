import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/widgets/custom_search_text_field.dart';
import 'package:nahkum/features/client/case_management/data/models/case_model.dart';
import 'package:nahkum/features/client/case_management/presentation/views/case_details_page.dart';
import '../../../../../core/models/case.dart';
import '../controllers/case_management_controller.dart';
import '../widgets/case_card.dart';
import '../widgets/case_offer_card.dart';
import '../../../home/presentation/widgets/bottom_navigation_bar.dart';
import '../../data/models/case_offer.dart';

class CaseManagementView extends GetView<CaseManagementController> {
  const CaseManagementView({super.key});

  @override
  Widget build(BuildContext context) {
    print('CaseManagementView: Building view');
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'قضاياي',
            style: TextStyle(
              color: AppColors.primary,
              fontFamily: 'Almarai',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        floatingActionButton: Obx(() => controller.currentTabIndex.value == 4
            ? FloatingActionButton(
                onPressed: () => Get.toNamed(Routes.PUBLISH_CASE),
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.add),
              )
            : const SizedBox.shrink()),
        body: Column(
          children: [
            CustomSearchTextField(
              controller: controller.searchController,
              hintText: 'ابحث باسم المحامي...',
              onChanged: controller.onSearchChanged,
              showFilterButton: false,
            ),
            Obx(() {
              return !controller.isSearching.value
                  ? TabBar(
                      controller: controller.tabController,
                      indicatorColor: const Color(0xFFC8A45D),
                      labelColor: AppColors.primary,
                      unselectedLabelColor: Colors.grey,
                      isScrollable: true,
                      padding: EdgeInsets.zero,
                      tabs: const [
                        Tab(text: 'بانتظار الموافقة'),
                        Tab(text: 'موافق عليها'),
                        Tab(text: 'مغلقة'),
                        Tab(text: 'الطلبات الواردة'),
                        Tab(text: 'المنشورات'),
                      ],
                    )
                  : const SizedBox();
            }),
            Expanded(
              child: Obx(() {
                print(
                    'CaseManagementView: Rebuilding list, isLoading: ${controller.isLoading.value}');

                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                final items = controller.getFilteredItems();
                print(
                    'CaseManagementView: Got ${items.length} items for tab ${controller.currentTabIndex.value}');

                if (items.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'لا توجد عناصر',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontFamily: 'Almarai',
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            print('CaseManagementView: Refresh button pressed');
                            controller.refreshActiveTab();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'تحديث',
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: RefreshIndicator(
                    onRefresh: () => controller.refreshActiveTab(),
                    color: AppColors.primary,
                    child: ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        print(
                            'CaseManagementView: Building item $index, type: ${item.runtimeType}');

                        if (controller.currentTabIndex.value == 3) {
                          final offer = item as CaseOffer;
                          return CaseOfferCard(
                            offer: offer,
                            onTap: () =>
                                controller.navigateToOfferDetails(offer),
                          );
                        } else {
                          final caseItem = item as Case;
                          print(
                              'CaseManagementView: Case item $index - id: ${caseItem.toJson()}');
                          return CaseCard(
                            caseItem: caseItem,
                            onTap: () {
                              final detailCase = CasePreview(
                                id: caseItem.id,
                                description: caseItem.description,
                                caseType: caseItem.caseType,
                                Status: caseItem.status,
                                requestStatus: '',
                                lawyerName: caseItem.lawyerName,
                                lawyerId: caseItem.lawyerId,
                                userId: caseItem.lawyerUserId,
                              );
                              Get.to(
                                  () => CaseDetailsPage(caseItem: detailCase));
                            },
                          );
                        }
                      },
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
        bottomNavigationBar: Builder(
          builder: (context) => Directionality(
            textDirection: TextDirection.ltr,
            child: const CustomBottomNavigationBar(currentIndex: 3),
          ),
        ),
      ),
    );
  }
}
