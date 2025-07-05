import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/utils/app_assets.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/features/judge/presentation/controllers/video_analysis_controller.dart';
import 'package:nahkum/features/judge/presentation/widgets/custom_bottom_navigation_judge_bar.dart';
import 'package:nahkum/features/judge/presentation/widgets/judge_app_bar.dart';
import 'package:nahkum/features/judge/presentation/widgets/predictions_list_view.dart';
import 'package:nahkum/features/judge/presentation/widgets/video_analysis_card.dart';

class VideoAnalysisView extends GetView<VideoAnalysisController> {
  const VideoAnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: JudgeAppBar(title: 'تحليل فيديو'),
      backgroundColor: const Color(0xFFFAFAFA),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  64.verticalSpace,
                  Text(
                    'قم برفع فيديو لتحليله باستخدام الذكاء الاصطناعي\nومراجعة نتائج الكشف عن الكذب.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                  28.verticalSpace,
                  Obx(() => controller.file.value == null
                      ? _buildUploadBox()
                      : _buildFilePreview()),
                  const SizedBox(height: 24),
                  Obx(() {
                    if (controller.isLoading.value) {
                      return Column(
                        children: [
                          80.verticalSpace,
                          Text(
                            'يتم الآن تحليل الفيديو ...',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                          35.verticalSpace,
                          CircularProgressIndicator(),
                        ],
                      );
                    }
                    if (controller.prediction.value == null) {
                      return Column(
                        children: [
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              'نتائج التحاليل السابقة',
                              style: TextStyle(
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp,
                                color: AppColors.primary,
                              ),
                              textDirection: TextDirection.rtl,
                            ),
                          ),
                          const SizedBox(height: 12),
                          PredictionsListView(),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            'نتيجة تحليل الفيديو',
                            style: TextStyle(
                              fontFamily: 'Almarai',
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp,
                              color: AppColors.primary,
                            ),
                            textDirection: TextDirection.rtl,
                          ),
                        ),
                        const SizedBox(height: 12),
                        VideoAnalysisCard(
                            predictionModel: controller.prediction.value!),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar:
          const CustomBottomNavigationJudgeBar(currentIndex: 3),
    );
  }

  Widget _buildUploadBox() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.gold.withOpacity(0.9)),
        color: AppColors.gold.withOpacity(0.1),
      ),
      child: Column(
        children: [
          SvgPicture.asset(AppAssets.document,
              width: 36, height: 36, color: AppColors.gold),
          const SizedBox(height: 12),
          const Text(
            'أختر من المعرض الفيديو الذي تريد تحليله',
            style: TextStyle(
              fontFamily: 'Almarai',
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 18),
          ElevatedButton(
            onPressed: controller.pickAndAnalyzeVideo,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'رفع فيديو',
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: 14,
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildFilePreview() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.gold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const Icon(Icons.videocam_rounded, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              controller.file.value!.path.split('/').last,
              style: const TextStyle(
                fontFamily: 'Almarai',
                fontSize: 13,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (controller.file.value != null)
            IconButton(
              onPressed: controller.cancelVideoPrediction,
              icon: Icon(Icons.close),
            ),
        ],
      ),
    );
  }
}
