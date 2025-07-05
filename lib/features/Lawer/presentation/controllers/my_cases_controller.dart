import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/repo/lawyer_repo.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/features/lawer/data/models/case_model.dart';

class MyCasesController extends GetxController
    with GetSingleTickerProviderStateMixin {
  LawyerRepo lawyerRepo = LawyerRepo();

  late TabController tabController;

  final RxList<CaseModel> activeCases = <CaseModel>[].obs;
  final RxList<CaseModel> closedCases = <CaseModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasError = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);

    tabController.index = 1;

    getMyCases();
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future<void> getMyCases() async {
    isLoading.value = true;

    final result = await lawyerRepo.getMyCases();
    if (result is DataSuccess) {
      activeCases.value = result.data!.myCases
          .where(
            (element) => element.status == 'active',
          )
          .toList();
      closedCases.value = result.data!.myCases
          .where(
            (element) => element.status != 'active',
          )
          .toList();
    }

    isLoading.value = false;
  }

  void navigateToCaseDetails(int caseId) {
    Get.toNamed(Routes.CASE_DETAILS, arguments: {
      'caseId': caseId,
      'fromScreen': 'lawyer_cases',
    });
  }

  Future<void> refreshCases() async {
    await getMyCases();
  }
}
