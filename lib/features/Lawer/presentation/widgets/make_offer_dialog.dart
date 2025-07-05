import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/widgets/custom_text_field.dart';
import 'package:nahkum/features/lawer/presentation/controllers/make_offer_controller.dart';

class MakeOfferDialog extends StatelessWidget {
  const MakeOfferDialog({super.key});

  @override
  Widget build(BuildContext context) {
    MakeOfferController controller = Get.put(MakeOfferController());
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
        child: SingleChildScrollView(
          child: Dialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          vertical: 26, horizontal: 15),
                      decoration: BoxDecoration(
                          color: const Color(0xFFC8A45D),
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'تقديم العرض',
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              fontSize: 14,
                              color: Color(0xffFFFFFF),
                            ),
                          ),
                          9.verticalSpace,
                          Text(
                            'قدم عرضك و وصف لمعالجة القضية',
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    18.verticalSpace,
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 21),
                      child: Form(
                        key: controller.makeOfferFormKey,
                        child: Column(
                          children: [
                            CustomTextField(
                              hintText: 'اكتب العرض',
                              labelText: 'العرض',
                              iconPath: 'assets/images/money.svg',
                              controller: controller.offerController,
                              keyboardType: TextInputType.number,
                              isBordered: true,
                              validator: (value) => value?.isEmpty ?? true
                                  ? 'هذا الحقل مطلوب'
                                  : null,
                            ),
                            const SizedBox(height: 16),
                            CustomTextField(
                              hintText: 'اكتب وصف لما ستفعله بالقضية',
                              labelText: 'وصف المعالجة',
                              iconPath: 'assets/images/money.svg',
                              controller: controller.noteController,
                              isBordered: true,
                              validator: (value) => value?.isEmpty ?? true
                                  ? 'هذا الحقل مطلوب'
                                  : null,
                            ),
                            30.verticalSpace,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('خروج',
                                      style: TextStyle(color: Colors.grey)),
                                ),
                                Obx(
                                  () {
                                    if (controller.isLoading.value) {
                                      return CircularProgressIndicator(
                                          color: AppColors.gold);
                                    } else {
                                      return TextButton(
                                        onPressed: controller.makeOffer,
                                        child: const Text('تم',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xff181E3C))),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                            36.verticalSpace,
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
