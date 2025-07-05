import 'package:get/get.dart';
import '../controllers/publish_case_controller.dart';

class PublishCaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PublishCaseController>(
      () => PublishCaseController(),
    );
  }
}
