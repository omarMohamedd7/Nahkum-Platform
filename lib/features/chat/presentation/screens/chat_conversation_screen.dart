import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/utils/app_styles.dart';
import 'package:nahkum/features/chat/presentation/controller/chat_controller.dart';
import 'package:nahkum/features/chat/presentation/widgets/message_card.dart';

class ChatConversationScreen extends GetView<ChatController> {
  const ChatConversationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            controller.contactModel.name,
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
          padding: EdgeInsets.all(10.h),
          child: Column(
            children: [
              Expanded(
                child: Obx(() {
                  var chatController = Get.find<ChatController>();
                  if (chatController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  var messages = chatController.messages.reversed.toList();
                  return ListView.separated(
                      dragStartBehavior: DragStartBehavior.down,
                      reverse: true,
                      controller: chatController.scrollController,
                      itemBuilder: (BuildContext context, int index) =>
                          MessageCard(message: messages[index]),
                      itemCount: messages.length,
                      separatorBuilder: (BuildContext context, int index) =>
                          25.verticalSpace);
                }),
              ),
              SizedBox(height: 10.h),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.1),
                  blurRadius: 15,
                  spreadRadius: 15,
                )
              ],
            ),
            padding: EdgeInsets.all(24),
            child: TextField(
              textDirection: TextDirection.rtl,
              controller: controller.textController,
              decoration: InputDecoration(
                hintText: '      أكتب رسالة....',
                hintTextDirection: TextDirection.rtl,
                hintStyle: AppStyles.bodyMedium.copyWith(
                  color: AppColors.textGrey,
                ),
                border: InputBorder.none,
                suffixIconConstraints: BoxConstraints(
                  maxHeight: 24.w,
                  maxWidth: 24.w,
                ),
                suffixIcon: SvgPicture.asset(
                  'assets/images/edit.svg',
                  width: 24.w,
                  height: 24.w,
                ),
                prefixIcon: GestureDetector(
                  onTap: controller.sendMessage,
                  child: CircleAvatar(
                      backgroundColor: AppColors.gold,
                      child: SvgPicture.asset('assets/images/send.svg')),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
