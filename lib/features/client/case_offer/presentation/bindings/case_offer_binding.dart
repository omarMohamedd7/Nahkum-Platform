import 'package:get/get.dart';
import '../controllers/case_offer_detail_controller.dart';

class CaseOfferBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CaseOfferDetailController>(
      () => CaseOfferDetailController(),
    );
  }
}
