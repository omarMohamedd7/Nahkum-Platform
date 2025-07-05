import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/utils/app_styles.dart';
import 'package:nahkum/features/chat/data/models/contact_model.dart';
import 'package:nahkum/features/chat/presentation/controller/contacts_controller.dart';

class ContactCard extends GetView<ContactsController> {
  const ContactCard({super.key, required this.contactModel});

  final ContactModel contactModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.white,
        border: Border.all(color: AppColors.goldLight),
      ),
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.CHAT_DETAIL, arguments: {
            'contactModel': contactModel,
          })!
              .whenComplete(() {
            controller.getContacts();
          });
        },
        child: ListTile(
          tileColor: AppColors.white,
          leading: ClipRRect(
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColors.white,
                ),
                child: SvgPicture.asset(
                  'assets/images/pero.svg',
                  fit: BoxFit.fill,
                  color: AppColors.primary,
                )),
          ),
          title: Text(
            contactModel.name,
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(
            contactModel.lastMessageDate != null
                ? formatDurationToString(
                    DateTime.now().difference(contactModel.lastMessageDate!))
                : "",
            style: AppStyles.bodyMedium.copyWith(
              color: AppColors.textGrey,
            ),
          ),
        ),
      ),
    );
  }
}

String formatDurationToString(Duration duration) {
  final int days = duration.inDays;
  final int hours = duration.inHours.remainder(24);
  final int minutes = duration.inMinutes.remainder(60);
  final int seconds = duration.inSeconds.remainder(60);

  List<String> parts = [];

  if (days > 0) {
    parts.add("$days أيام ");
  }

  if (hours > 0 || (parts.isNotEmpty && parts.last.endsWith('day'))) {
    parts.add("$hours ساعات ");
  }

  if (minutes > 0 || (parts.isNotEmpty && parts.last.endsWith('hour'))) {
    parts.add("$minutes دقائق ");
  }

  if (seconds > 0) {
    parts.add("الآن");
  }
  if (parts.length > 1) parts.removeLast();
  return parts.join().trim();
}
