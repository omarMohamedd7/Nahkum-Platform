import 'package:get/get.dart';
import 'package:nahkum/features/auth/presentation/controllers/otp_controller.dart';

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<OtpController>(OtpController());
  }
}
