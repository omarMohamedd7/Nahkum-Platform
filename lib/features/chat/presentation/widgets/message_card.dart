import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/utils/app_styles.dart';
import 'package:nahkum/features/chat/data/models/conversation_model.dart';

class MessageCard extends StatelessWidget {
  const MessageCard({super.key, required this.message});
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          !message.isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!message.isSender) 0.4.sw.horizontalSpace,
        Flexible(
          child: Column(
            crossAxisAlignment: message.isSender
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
                decoration: BoxDecoration(
                    color: (message.isSender
                        ? message.isSending
                            ? Color.alphaBlend(
                                Colors.grey.withOpacity(0.8),
                                AppColors.gold,
                              )
                            : AppColors.gold
                        : null),
                    border: Border.all(
                      color: Color(0xffBFBFBF),
                    ),
                    borderRadius: BorderRadiusDirectional.only(
                      topStart: Radius.circular(12.r),
                      topEnd: Radius.circular(12.r),
                      bottomEnd: !message.isSender
                          ? Radius.zero
                          : Radius.circular(12.r),
                      bottomStart: message.isSender
                          ? Radius.zero
                          : Radius.circular(12.r),
                    )),
                child: Padding(
                  padding: EdgeInsets.all(10.h),
                  child: Text(
                    message.message,
                    style: AppStyles.bodyMedium.copyWith(
                      color:
                          message.isSender ? Colors.white : Color(0xff737373),
                    ),
                  ),
                ),
              ),
              4.verticalSpace,
              Text(message.formattedDate()),
            ],
          ),
        ),
        if (message.isSender) 0.4.sw.horizontalSpace,
      ],
    );
  }
}
