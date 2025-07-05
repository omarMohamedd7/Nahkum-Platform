import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/utils/app_assets.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/features/notifications/presentation/controllers/notifications_controller.dart';
import 'package:nahkum/features/notifications/presentation/widgets/notification_card.dart';

class NotificationsView extends GetView<NotificationsController> {
  const NotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.screenBackground,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          'الإشعارات',
          style: TextStyle(
            color: Color(0xFF181E3C),
            fontFamily: 'Almarai',
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: SvgPicture.asset(
              AppAssets.arrowRight,
              color: AppColors.primary,
            ),
            onPressed: () => Get.back(),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFC8A45D),
                      ),
                    );
                  }

                  if (controller.notifications.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            'assets/images/notification.svg',
                            width: 64,
                            height: 64,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'لا توجد إشعارات',
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: controller.notifications.length,
                    itemBuilder: (context, index) {
                      final notification = controller.notifications[index];
                      return NotificationCard(
                        title: notification.title,
                        description: notification.description,
                        time: notification.time,
                        notificationIconPath: 'assets/images/notification2.svg',
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
