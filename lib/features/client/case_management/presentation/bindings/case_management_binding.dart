import 'package:get/get.dart';
import '../controllers/case_management_controller.dart';

class CaseManagementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CaseManagementController>(
      () => CaseManagementController(),
    );
  }
}
