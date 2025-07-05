import 'package:get/get.dart';
import 'package:nahkum/features/judge/presentation/controllers/tasks_controller.dart';

class TasksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TasksController>(() => TasksController());
  }
}
