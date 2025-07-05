import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/utils/app_assets.dart';

class AIAssistCard extends StatelessWidget {
  const AIAssistCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFDF6E9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.gold.withOpacity(0.1),
              ),
              child: SvgPicture.asset(
                AppAssets.activeHome,
                width: 24,
                height: 24,
                color: AppColors.gold,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'حلّ قضيتك بالذكاء الصناعي',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'قم برفع تسجيلات الفيديو الخاصة بالقضية ليتم معالجتها عبر تقنيات متقدمة لاكتشاف مؤشرات الكذب، ومساعدتك في اتخاذ قرارات أكثر عدلاً وموضوعية.',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 12,
                      color: AppColors.textPrimary,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
