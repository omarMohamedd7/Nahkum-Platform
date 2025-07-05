import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/features/chat/presentation/controller/contacts_controller.dart';
import 'package:nahkum/features/chat/presentation/widgets/contact_card.dart';
import 'package:nahkum/features/client/home/presentation/widgets/bottom_navigation_bar.dart';
import 'package:nahkum/features/onboarding/data/models/user_role.dart';

class ContactsScreens extends GetView<ContactsController> {
  const ContactsScreens({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'المحادثات',
            style: TextStyle(
              color: AppColors.primary,
              fontFamily: 'Almarai',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.h),
          child: Obx(
            () {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.contacts.isEmpty) {
                return const Center(
                  child: Text(
                    'لا يوجد بيانات للعرض',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontFamily: 'Almarai',
                      fontSize: 16,
                    ),
                  ),
                );
              }
              return ListView.separated(
                itemCount: controller.contacts.length,
                itemBuilder: (_, index) =>
                    ContactCard(contactModel: controller.contacts[index]),
                separatorBuilder: (BuildContext context, int index) =>
                    16.verticalSpace,
              );
            },
          ),
        ),
        bottomNavigationBar: (controller.userModel.role == UserRole.client.name)
            ? CustomBottomNavigationBar(
                key: const ValueKey('settings_view_bottom_nav'),
                currentIndex: 1,
              )
            : null);
  }
}
