import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nahkum/features/judge/presentation/controllers/tasks_controller.dart';
import 'package:nahkum/features/judge/presentation/widgets/ai_assist_card.dart';
import 'package:nahkum/features/judge/presentation/widgets/custom_bottom_navigation_judge_bar.dart';
import 'package:nahkum/features/judge/presentation/widgets/task_card.dart';
import 'package:nahkum/features/judge/presentation/widgets/tasks_header.dart';
import 'package:nahkum/features/judge/presentation/widgets/top_bar.dart';
import 'package:nahkum/features/judge/presentation/widgets/welcome_card.dart';

class JudgeHomeView extends GetView<TasksController> {
  const JudgeHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(height: 43),
                JudgeHomeTopBar(),
                SizedBox(height: 16),
                JudgeWelcomeSection(),
                SizedBox(height: 16),
                AIAssistCard(),
                SizedBox(height: 24),
                TasksHeader(),
                SizedBox(height: 12),
                Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.tasks.isEmpty) {
                    return const Center(child: Text('لا توجد مهام حالياً'));
                  }

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.only(bottom: 100),
                    itemCount: controller.tasks.length,
                    itemBuilder: (context, index) {
                      final task = controller.tasks[index];
                      return TaskCard(task: task);
                    },
                    separatorBuilder: (context, index) => 28.verticalSpace,
                  );
                }),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationJudgeBar(
        key: ValueKey('home_view_bottom_nav'),
        currentIndex: 0,
      ),
    );
  }
}
