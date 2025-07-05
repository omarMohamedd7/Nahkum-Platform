import 'package:get/get.dart';
import 'package:nahkum/features/auth/presentation/controllers/forget_password_controller.dart';

class ForgetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ForgetPasswordController>(ForgetPasswordController());
  }
}
