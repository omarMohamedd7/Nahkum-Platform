import 'package:get/get.dart';
import '../controllers/agencies_controller.dart';

class AgenciesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AgenciesController>(
      () => AgenciesController(),
    );
  }
}
