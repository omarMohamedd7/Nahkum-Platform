import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/repo/judge_repo.dart';
import 'package:nahkum/core/routes/app_routes.dart';

class AddTaskController extends GetxController {
  final JudgeRepo _judgeRepo = JudgeRepo();

  final taskFormKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  final RxBool isLoading = false.obs;

  Future<void> submitTask() async {
    if (!taskFormKey.currentState!.validate()) return;
    isLoading(true);
    final result = await _judgeRepo.addTask(
      title: titleController.text,
      description: descriptionController.text,
      date: dateController.text,
      time: timeController.text,
    );

    if (result is DataSuccess) {
      Get.offAllNamed(Routes.Judge_HOME);
      Get.snackbar(
        'تم',
        result.data?.message ?? 'تمت إضافة المهمة بنجاح',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } else {
      Get.snackbar(
        'خطأ',
        result.error.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }

    isLoading(false);
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.onClose();
  }
}
