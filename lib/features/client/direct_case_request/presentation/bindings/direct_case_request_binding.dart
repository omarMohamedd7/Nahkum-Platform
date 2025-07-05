import 'package:get/get.dart';
import '../controllers/direct_case_request_controller.dart';

class DirectCaseRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DirectCaseRequestController>(
      () => DirectCaseRequestController(),
    );
  }
}
