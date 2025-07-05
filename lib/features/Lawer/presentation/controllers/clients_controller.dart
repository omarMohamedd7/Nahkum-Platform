import 'package:get/get.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/repo/lawyer_repo.dart';
import 'package:nahkum/features/lawer/data/models/case_model.dart';

class ClientsController extends GetxController {
  LawyerRepo lawyerRepo = LawyerRepo();

  final RxBool isLoading = false.obs;

  RxList<CaseModel> clients = <CaseModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    getClients();
  }

  Future<void> getClients() async {
    isLoading(true);
    final result = await lawyerRepo.getClientsCases();
    if (result is DataSuccess) {
      clients.value = result.data!.cases;
    }
    isLoading(false);
  }

  String getCaseTypeForClient(int clientId) {
    switch (clientId) {
      case 1:
        return 'قضية مدنية';
      case 2:
        return 'قضية جنائية';
      case 3:
        return 'قضية تجارية';
      case 4:
        return 'قضية أحوال شخصية';
      case 5:
        return 'قضية إدارية';
      default:
        return 'قضية أخرى';
    }
  }
}
