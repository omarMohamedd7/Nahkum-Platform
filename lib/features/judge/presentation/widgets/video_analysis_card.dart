import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/features/judge/data/models/prediction_model.dart';

class VideoAnalysisCard extends StatelessWidget {
  const VideoAnalysisCard({super.key, required this.predictionModel});
  final PredictionModel predictionModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          infoRow(title: 'اسم الفيديو:', subtitle: predictionModel.name),
          4.verticalSpace,
          infoRow(title: 'مدة الفيديو:', subtitle: predictionModel.duration),
          4.verticalSpace,
          infoRow(title: 'تاريخ الرفع:', subtitle: predictionModel.date),
          16.verticalSpace,
          Divider(),
          16.verticalSpace,
          Text(
            'النظام يقدر أن الشخص كان ${predictionModel.isLier ? 'كاذباً' : 'صادقاً'} بنسبة ${predictionModel.confidencePercentage} خلال الفيديو.',
            style: TextStyle(
              fontFamily: 'Almarai',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.gold,
            ),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
          8.verticalSpace,
          Text(
            'تحليل الذكاء الاصطناعي أظهر أن الشخص كان ${predictionModel.isLier ? 'كاذباً' : 'صادقاً'}  في معظم الأجوبة، مع وجود فترات شك.',
            style: const TextStyle(
              fontFamily: 'Almarai',
              fontSize: 13,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.right,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Row infoRow({
    required String title,
    required String subtitle,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          flex: 3,
          child: Text(
            subtitle,
            style: TextStyle(
              fontFamily: 'Almarai',
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textGrey,
            ),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.end,
          ),
        ),
        8.horizontalSpace,
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
            textDirection: TextDirection.rtl,
          ),
        ),
      ],
    );
  }
}
