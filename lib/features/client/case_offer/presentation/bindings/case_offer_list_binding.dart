import 'package:get/get.dart';
import '../controllers/case_offer_controller.dart';

class CaseOfferListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CaseOfferController>(
      () => CaseOfferController(),
    );
  }
}
