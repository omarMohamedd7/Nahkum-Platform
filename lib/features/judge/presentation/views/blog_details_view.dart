import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/utils/app_assets.dart';
import 'package:nahkum/features/judge/presentation/controllers/blog_details_controller.dart';

class BlogDetailsView extends StatelessWidget {
  const BlogDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BlogDetailsController>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'تفاصيل المرجع',
            style: TextStyle(
              fontFamily: 'Almarai',
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        backgroundColor: const Color(0xFFFAFAFA),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 32),
                Column(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF5F0E6),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          AppAssets.document,
                          width: 28,
                          color: AppColors.gold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      controller.book.title,
                      style: const TextStyle(
                        fontFamily: 'Almarai',
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      controller.book.category,
                      style: const TextStyle(
                        fontFamily: 'Almarai',
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                const Text(
                  'نبذة عن الكتاب:',
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.book.description,
                  style: const TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.right,
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: controller.downloadReference,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'تحميل',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
