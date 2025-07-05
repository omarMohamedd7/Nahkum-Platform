import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/features/judge/presentation/controllers/books_controller.dart';
import 'package:nahkum/features/judge/presentation/widgets/blog_card.dart';
import 'package:nahkum/features/judge/presentation/widgets/custom_bottom_navigation_judge_bar.dart';
import 'package:nahkum/features/judge/presentation/widgets/judge_app_bar.dart';

class BlogsView extends StatelessWidget {
  const BlogsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BooksController());

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: JudgeAppBar(title: 'المراجع القانونية'),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: TextField(
                  onChanged: controller.updateSearch,
                  decoration: const InputDecoration(
                    hintText: 'ابحث عن كتاب أو مرجع...',
                    hintStyle: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.filteredBooks.isEmpty) {
                    return const Center(child: Text('لا توجد نتائج'));
                  }
                  return ListView.builder(
                    itemCount: controller.filteredBooks.length,
                    itemBuilder: (context, index) {
                      final book = controller.filteredBooks[index];
                      return BlogCard(
                        title: book.title,
                        subtitle: book.category,
                        description: book.description,
                        onTap: () {
                          Get.toNamed(
                            Routes.blog_details,
                            arguments: {'book': book.toJson()},
                          );
                        },
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationJudgeBar(
        key: ValueKey('books_bottom_nav'),
        currentIndex: 1,
      ),
    );
  }
}
