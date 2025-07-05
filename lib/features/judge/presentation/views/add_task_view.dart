import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import '../controllers/add_task_controller.dart';
import '../widgets/add_task_form.dart';

class AddTaskView extends GetView<AddTaskController> {
  const AddTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'إضافة مهمة جديدة',
            style: TextStyle(
              fontFamily: 'Almarai',
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        backgroundColor: const Color(0xFFFAFAFA),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: AddTaskForm(controller: controller),
          ),
        ),
      ),
    );
  }
}
