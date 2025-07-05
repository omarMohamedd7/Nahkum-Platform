import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/widgets/custom_search_text_field.dart';
import 'package:nahkum/features/client/case_management/data/models/case_offer.dart';
import '../controllers/case_offer_controller.dart';
import '../widgets/case_offer_card.dart';
import '../../../home/presentation/widgets/bottom_navigation_bar.dart';

class CaseOfferListView extends GetView<CaseOfferController> {
  const CaseOfferListView({super.key});

  @override
  Widget build(BuildContext context) {
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
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined,
                  color: Color(0xFFBFBFBF)),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            CustomSearchTextField(
              controller: controller.searchController,
              hintText: 'أبحث باستخدام رقم القضية...',
              onChanged: controller.onSearchChanged,
              showFilterButton: false,
            ),
            Obx(() {
              return !controller.isSearching.value
                  ? Column(
                      children: [
                        Container(
                          height: 50,
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xFFBFBFBF),
                                width: 1,
                              ),
                            ),
                          ),
                          child: TabBar(
                            controller: controller.tabController,
                            indicatorColor: AppColors.primary,
                            labelColor: AppColors.primary,
                            unselectedLabelColor: const Color(0xFFBFBFBF),
                            labelStyle: const TextStyle(
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                            unselectedLabelStyle: const TextStyle(
                              fontFamily: 'Almarai',
                              fontSize: 14,
                            ),
                            tabs: const [
                              Tab(text: 'بانتظار الموافقة'),
                              Tab(text: 'فعالة'),
                              Tab(text: 'مغلقة'),
                              Tab(text: 'الطلبات الواردة'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    )
                  : const SizedBox();
            }),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  );
                }

                final filteredOffers = controller.getFilteredOffers();

                if (filteredOffers.isEmpty) {
                  return const Center(
                    child: Text(
                      'لا توجد عروض',
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontFamily: 'Almarai',
                        fontSize: 16,
                      ),
                    ),
                  );
                }

                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: filteredOffers.length,
                    itemBuilder: (context, index) {
                      final offer = filteredOffers[index];
                      return CaseOfferCard(
                        offer: offer,
                        onTap: () => controller.navigateToOfferDetails(offer),
                      );
                    },
                  ),
                );
              }),
            ),
          ],
        ),
        bottomNavigationBar: const CustomBottomNavigationBar(
            key: ValueKey('case_offer_list_view_bottom_nav'), currentIndex: 2),
      ),
    );
  }
}
