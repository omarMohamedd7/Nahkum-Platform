import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:nahkum/features/judge/presentation/controllers/video_analysis_controller.dart';
import 'package:nahkum/features/judge/presentation/widgets/video_analysis_card.dart';

class PredictionsListView extends GetView<VideoAnalysisController> {
  const PredictionsListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingPredictions.value) {
        return Column(
          children: [
            100.verticalSpace,
            const Center(child: CircularProgressIndicator()),
          ],
        );
      }

      if (controller.predictions.isEmpty) {
        return Column(
          children: [
            100.verticalSpace,
            const Center(child: Text('لا توجد تحاليل سابقة حالياً')),
          ],
        );
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(bottom: 100),
        itemCount: controller.predictions.length,
        itemBuilder: (context, index) {
          final predictionModel = controller.predictions[index];
          return VideoAnalysisCard(predictionModel: predictionModel);
        },
        separatorBuilder: (context, index) => 28.verticalSpace,
      );
    });
  }
}
