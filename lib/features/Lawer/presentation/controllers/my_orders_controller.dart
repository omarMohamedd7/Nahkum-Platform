import 'package:get/get.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/repo/lawyer_repo.dart';
import 'package:nahkum/features/lawer/data/models/case_request_model.dart';

class MyOrdersController extends GetxController {
  LawyerRepo lawyerRepo = LawyerRepo();

  final RxBool isLoading = false.obs;

  RxList<CaseRequestModel> caseRequests = <CaseRequestModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    getCaseRequests();
  }

  Future<void> getCaseRequests() async {
    isLoading(true);
    final result = await lawyerRepo.getClientCaseRequests();
    if (result is DataSuccess) {
      caseRequests.value = result.data!.cases;
    }
    isLoading(false);
  }
}
