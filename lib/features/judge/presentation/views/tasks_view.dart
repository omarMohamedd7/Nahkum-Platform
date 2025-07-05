import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/features/judge/presentation/controllers/tasks_controller.dart';
import 'package:nahkum/features/judge/presentation/widgets/custom_bottom_navigation_judge_bar.dart';
import 'package:nahkum/features/judge/presentation/widgets/judge_app_bar.dart';
import 'package:nahkum/features/judge/presentation/widgets/task_card.dart';

class TasksView extends StatelessWidget {
  const TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    final TasksController controller = Get.put(TasksController());

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: JudgeAppBar(title: 'مهامي'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.tasks.isEmpty) {
            return const Center(child: Text('لا توجد مهام حالياً'));
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.only(bottom: 100),
                  itemCount: controller.tasks.length,
                  itemBuilder: (context, index) {
                    final task = controller.tasks[index];
                    return TaskCard(task: task);
                  },
                  separatorBuilder: (context, index) => 28.verticalSpace,
                ),
              ),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200)),
        backgroundColor: AppColors.primary,
        onPressed: () => Get.toNamed(Routes.add_task),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar:
          const CustomBottomNavigationJudgeBar(currentIndex: 2),
    );
  }
}
