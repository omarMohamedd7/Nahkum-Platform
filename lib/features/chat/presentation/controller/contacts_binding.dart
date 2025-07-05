import 'package:get/get.dart';
import 'package:nahkum/features/chat/presentation/controller/contacts_controller.dart';

class ContactsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ContactsController>(ContactsController());
  }
}
