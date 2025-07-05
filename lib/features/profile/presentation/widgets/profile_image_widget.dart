import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/data/data_consts.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/features/profile/presentation/controller/profile_controller.dart';

class ProfileImageWidget extends GetView<ProfileController> {
  const ProfileImageWidget({
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Stack(
          children: [
            Container(
              height: 110.w,
              width: 110.w,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.gold,
                  width: 2.w,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: controller.imageToEdit.value != null
                      ? FutureBuilder(
                          future: controller.imageToEdit.value!.readAsBytes(),
                          builder: (context, snapshot) {
                            if (snapshot.data == null) {
                              return const SizedBox();
                            }
                            return Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                            );
                          },
                        )
                      : Builder(builder: (context) {
                          if (controller.profile!.profileImageUrl == null) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SvgPicture.asset(
                                'assets/images/pero.svg',
                                color: AppColors.primary,
                              ),
                            );
                          }
                          return Image.network(
                            '${DataConsts.domain}/${controller.profile!.profileImageUrl!}',
                            fit: BoxFit.cover,
                          );
                        }),
                ),
              ),
            ),
            PositionedDirectional(
              bottom: 9.h,
              start: 6.w,
              child: GestureDetector(
                onTap: controller.showImageSourceDialog,
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: SvgPicture.asset(
                    'assets/images/edit.svg',
                    height: 18.w,
                    width: 18.w,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
