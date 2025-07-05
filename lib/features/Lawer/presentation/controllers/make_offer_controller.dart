import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/repo/lawyer_repo.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/features/lawer/data/models/case_request_model.dart';

class MakeOfferController extends GetxController {
  LawyerRepo lawyerRepo = LawyerRepo();
  final CaseRequestModel caseRequestModel = Get.arguments['case'];

  final RxBool isLoading = false.obs;

  final makeOfferFormKey = GlobalKey<FormState>();
  TextEditingController offerController = TextEditingController();
  TextEditingController noteController = TextEditingController();

  Future<void> makeOffer() async {
    if (!makeOfferFormKey.currentState!.validate()) return;
    isLoading(true);
    final result = await lawyerRepo.makeOffer(
      caseId: caseRequestModel.requestId,
      expectedPrice: offerController.text,
      message: noteController.text,
    );
    if (result is DataSuccess) {
      Get.offAllNamed(Routes.LAWYER_HOME);
      Get.snackbar(
        'تم',
        result.data!.message.toString(),
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'خطأ',
        result.error.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
    isLoading(false);
  }
}
