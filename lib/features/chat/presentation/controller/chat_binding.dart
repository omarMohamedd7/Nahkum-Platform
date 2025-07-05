import 'package:get/get.dart';
import 'package:nahkum/features/chat/presentation/controller/chat_controller.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ChatController>(ChatController());
  }
}
