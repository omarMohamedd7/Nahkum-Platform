import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/widgets/custom_text_field.dart';
import 'package:nahkum/features/judge/presentation/widgets/label_widget.dart';
import 'package:nahkum/features/judge/presentation/controllers/add_task_controller.dart';

class AddTaskForm extends StatelessWidget {
  final AddTaskController controller;

  const AddTaskForm({super.key, required this.controller});

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      locale: const Locale('ar'),
    );
    if (picked != null) {
      controller.dateController.text = DateFormat('yyyy-MM-dd').format(picked);
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      final now = DateTime.now();
      final dt =
          DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
      controller.timeController.text = DateFormat('HH:mm').format(dt);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.taskFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          38.verticalSpace,
          const LabelWidget(text: 'عنوان المهمة'),
          CustomTextField(
            controller: controller.titleController,
            hintText: 'أدخل عنوان المهمة',
            validator: (val) => val!.isEmpty ? 'هذا الحقل مطلوب' : null,
          ),
          38.verticalSpace,
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LabelWidget(text: 'تاريخ تنفيذ المهمة'),
                    CustomTextField(
                      onTap: () => _pickDate(context),
                      readOnly: true,
                      controller: controller.dateController,
                      hintText: 'YYYY-MM-DD',
                      validator: (val) => val!.isEmpty ? 'مطلوب' : null,
                    ),
                  ],
                ),
              ),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LabelWidget(text: 'وقت بدء المهمة'),
                    CustomTextField(
                      onTap: () => _pickTime(context),
                      readOnly: true,
                      controller: controller.timeController,
                      hintText: 'HH:MM',
                      validator: (val) => val!.isEmpty ? 'مطلوب' : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
          38.verticalSpace,
          const LabelWidget(text: 'وصف إضافي (اختياري)'),
          CustomTextField(
            controller: controller.descriptionController,
            hintText: 'أدخل وصف المهمة',
          ),
          38.verticalSpace,
          SizedBox(
            width: double.infinity,
            height: 50,
            child: Obx(() {
              return ElevatedButton(
                onPressed:
                    controller.isLoading.value ? null : controller.submitTask,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isLoading.value
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'تم',
                        style: TextStyle(
                          fontFamily: 'Almarai',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              );
            }),
          ),
          38.verticalSpace,
        ],
      ),
    );
  }
}
