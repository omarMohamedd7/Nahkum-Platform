import 'package:get/get.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/repo/lawyer_repo.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/features/lawer/data/models/case_request_model.dart';
import 'package:nahkum/features/lawer/data/models/published_case_model.dart';

class HomeController extends GetxController {
  LawyerRepo lawyerRepo = LawyerRepo();

  final RxBool isCaseLoading = false.obs;
  final RxBool isPublishedLoading = false.obs;

  RxList<CaseRequestModel> caseRequests = <CaseRequestModel>[].obs;
  RxList<PublishedCaseModel> publishedCases = <PublishedCaseModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    getCaseRequests();
    getAvailableCases();
  }

  Future<void> getCaseRequests() async {
    isCaseLoading(true);
    final result = await lawyerRepo.getClientCaseRequests();
    if (result is DataSuccess) {
      caseRequests.value = result.data!.cases;
    }
    isCaseLoading(false);
  }

  Future<void> getAvailableCases() async {
    isPublishedLoading(true);
    final result = await lawyerRepo.getAvailableCases();
    if (result is DataSuccess) {
      publishedCases.value = result.data!.availbleCases;
    }
    isPublishedLoading(false);
  }

  void navigateToPublishedCaseDetails(PublishedCaseModel caseData) {
    Get.toNamed(Routes.LAWYER_SUBMIT_OFFER, arguments: {
      'caseType': caseData.caseDetails.caseType,
      'city': caseData.client.city,
      'caseId': caseData.caseDetails.caseId,
    });
  }

  void navigateToAllAttorneyRequests() {
    Get.offAllNamed(Routes.LAWYER_ORDERS);
  }

  void navigateToAllPublishedCases() {
    Get.offAllNamed(Routes.LAWYER_AGENCIES);
  }
}
