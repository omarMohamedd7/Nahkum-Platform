import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/features/lawer/data/models/case_request_model.dart';
import 'package:nahkum/features/lawer/presentation/widgets/lawyer_app_bar.dart';
import '../widgets/lawyer_bottom_navigation_bar.dart';
import '../controllers/my_orders_controller.dart';

class MyOrdersView extends GetView<MyOrdersController> {
  const MyOrdersView({super.key});

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
              child: LawyerAppBar(title: 'طلباتي'),
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.gold),
                    );
                  }

                  final orders = controller.caseRequests;

                  if (orders.isEmpty) {
                    return Center(
                      child: Text(
                        'لا توجد طلبات توكيل',
                        style: const TextStyle(
                          color: AppColors.textSecondary,
                          fontFamily: 'Almarai',
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      return _buildRequestCard(orders[index]);
                    },
                  );
                }),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const LawyerBottomNavigationBar(currentIndex: 4),
    );
  }

  Widget _buildRequestCard(CaseRequestModel order) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.LAWYER_CaseDetailsView, arguments: {
          'case': order,
          'isPublished': false,
        });
      },
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: order.status.getStatusColor().withOpacity(0.1),
                  ),
                  child: Text(
                    order.status.getLocalizedStatus(),
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: order.status.getStatusColor(),
                    ),
                  ),
                ),
                Text(
                  order.caseDetails.caseType,
                  style: const TextStyle(
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'اسم الموكل: ${order.client?.name}',
              style: const TextStyle(
                fontFamily: 'Almarai',
                fontSize: 12,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 4),
            Text(
              'رقم القضية: ${order.caseDetails.caseNumber}',
              style: const TextStyle(
                fontFamily: 'Almarai',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 4),
            Text(
              'تاريخ الطلب: ${order.getFormattedDate()}',
              style: const TextStyle(
                fontFamily: 'Almarai',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.right,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 8),
            Text(
              order.caseDetails.description,
              style: const TextStyle(
                fontFamily: 'Almarai',
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {},
              child: Row(
                children: const [
                  Icon(Icons.arrow_back_ios,
                      size: 16, color: AppColors.primary),
                  SizedBox(width: 4),
                  Text(
                    'تفاصيل',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
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
