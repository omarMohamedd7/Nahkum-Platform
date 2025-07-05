import 'package:get/get.dart';
import 'package:nahkum/features/auth/presentation/controllers/reset_password_controller.dart';

class ResetPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ResetPasswordController>(ResetPasswordController());
  }
}
