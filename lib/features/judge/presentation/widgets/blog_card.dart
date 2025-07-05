import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/utils/app_assets.dart';

class BlogCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final VoidCallback? onTap;

  const BlogCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SvgPicture.asset(
                  AppAssets.document,
                  color: AppColors.gold,
                  width: 20,
                ),
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Almarai',
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: AppColors.primary,
                    ),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'Almarai',
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.right,
            ),
            const SizedBox(height: 10),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: description.length > 75
                        ? description.substring(0, 75)
                        : description,
                    style: const TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (description.length > 75)
                    const TextSpan(
                      text: '... عرض المزيد',
                      style: TextStyle(
                        fontFamily: 'Almarai',
                        fontSize: 13,
                        color: AppColors.gold,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }
}
