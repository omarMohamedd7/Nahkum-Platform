import 'package:get/get.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/repo/lawyer_repo.dart';
import 'package:nahkum/features/lawer/data/models/published_case_model.dart';

class AgenciesController extends GetxController {
  LawyerRepo lawyerRepo = LawyerRepo();

  final RxBool isLoading = false.obs;

  RxList<PublishedCaseModel> publishedCases = <PublishedCaseModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    getAvailableCases();
  }

  Future<void> getAvailableCases() async {
    isLoading(true);
    final result = await lawyerRepo.getAvailableCases();
    if (result is DataSuccess) {
      publishedCases.value = result.data!.availbleCases;
    }
    isLoading(false);
  }
}
