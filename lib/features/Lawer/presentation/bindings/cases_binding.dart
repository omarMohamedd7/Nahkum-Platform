import 'package:get/get.dart';
import '../controllers/my_cases_controller.dart';

class CasesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyCasesController>(
      () => MyCasesController(),
    );
  }
}
