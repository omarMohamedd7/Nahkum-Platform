import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/utils/app_assets.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/features/judge/presentation/controllers/tasks_controller.dart';
import 'package:nahkum/features/judge/presentation/views/add_task_view.dart';
import 'package:nahkum/features/judge/presentation/widgets/custom_bottom_navigation_judge_bar.dart';

class TasksView extends StatelessWidget {
  const TasksView({super.key});

  @override
  Widget build(BuildContext context) {
    final TasksController controller = Get.put(TasksController());

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'مهامي',
          style: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.grey[600]),
            onPressed: () {},
          ),
        ],
      ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'المهام',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'عرض الكل',
                      style: TextStyle(
                        fontFamily: 'Almarai',
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: AppColors.gold,
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.tasks.length,
                  itemBuilder: (context, index) {
                    final task = controller.tasks[index];

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(width: 6),
                                    Text(
                                      task.title,
                                      style: const TextStyle(
                                        fontFamily: 'Almarai',
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ),
                                SvgPicture.asset(
                                  AppAssets.document,
                                  width: 20,
                                  height: 20,
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  task.time,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Almarai',
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.access_time, size: 16),
                                const SizedBox(width: 16),
                                Text(
                                  task.date,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontFamily: 'Almarai',
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(Icons.calendar_today, size: 16),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              task.description,
                              style: const TextStyle(
                                fontFamily: 'Almarai',
                                fontSize: 12,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () => Get.to(() => AddTaskView()),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar:
          const CustomBottomNavigationJudgeBar(currentIndex: 2),
    );
  }
}
