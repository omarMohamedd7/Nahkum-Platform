import 'package:get/get.dart';
import 'package:nahkum/features/client/payment/presentation/controllers/payment_controller.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PaymentController());
  }
}
