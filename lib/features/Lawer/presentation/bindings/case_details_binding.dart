import 'package:get/get.dart';
import 'package:nahkum/features/lawer/presentation/controllers/case_details_controller.dart';

class CaseDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CaseDetailsController>(
      () => CaseDetailsController(),
    );
  }
}
