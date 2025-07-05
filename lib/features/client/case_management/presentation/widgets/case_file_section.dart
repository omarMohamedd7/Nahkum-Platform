import 'package:flutter/material.dart';
import 'package:nahkum/core/data/data_consts.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class CaseFileSection extends StatelessWidget {
  final String title;
  final String fileCount;

  const CaseFileSection({
    super.key,
    required this.title,
    required this.fileCount,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // launch(DataConsts.imageBaseURL);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFC8A45D).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFBFBFBF),
            width: 1,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontFamily: 'Almarai',
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              fileCount,
              style: const TextStyle(
                color: Color(0xFF777777),
                fontFamily: 'Almarai',
                fontSize: 11,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.fullscreen,
                  size: 16,
                  color: Color(0xFFC8A45D),
                ),
                const SizedBox(width: 4),
                Text(
                  'عرض الصور',
                  style: TextStyle(
                    color: const Color(0xFFC8A45D),
                    fontFamily: 'Almarai',
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
