import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/repo/lawyer_repo.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/features/lawer/data/models/case_request_model.dart';

class CaseDetailsController extends GetxController {
  LawyerRepo lawyerRepo = LawyerRepo();
  final CaseRequestModel caseRequestModel = Get.arguments['case'];
  final bool isPublished = Get.arguments['isPublished'];

  RxList<String> files = RxList.empty();
  final RxBool isLoading = false.obs;

  Future<void> getCaseAttachments() async {
    isLoading(true);
    final result = await lawyerRepo.getCaseAttachments(
      caseRequestModel.caseDetails.caseId,
    );
    if (result is DataSuccess) {
      files.value = result.data!.files;
    }
    isLoading(false);
  }

  bool hasOffered() {
    if ((Get.arguments as Map<String, dynamic>).containsKey('hasOffered')) {
      return Get.arguments['hasOffered'];
    }
    return false;
  }

  final RxBool isAcceptRejectLoading = false.obs;
  Future<void> acceptRejectCaseRequest({required bool isAccept}) async {
    isAcceptRejectLoading(true);
    final result = await lawyerRepo.acceptRejectCaseRequest(
      requestId: caseRequestModel.requestId,
      action: isAccept ? 'accept' : 'reject',
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
    isAcceptRejectLoading(false);
  }

  @override
  void onInit() {
    getCaseAttachments();
    super.onInit();
  }
}
