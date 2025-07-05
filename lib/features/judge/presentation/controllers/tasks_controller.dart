import 'package:get/get.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/repo/judge_repo.dart';
import 'package:nahkum/features/judge/data/models/task_model.dart';

class TasksController extends GetxController {
  final JudgeRepo _judgeRepo = JudgeRepo();

  final RxBool isLoading = false.obs;
  final RxList<TaskModel> tasks = <TaskModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    isLoading(true);
    final result = await _judgeRepo.getTasks();
    if (result is DataSuccess) {
      tasks.value = result.data?.data ?? [];
    }
    isLoading(false);
  }
}
