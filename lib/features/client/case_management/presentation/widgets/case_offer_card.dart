import 'package:flutter/material.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import '../../data/models/case_offer.dart';

class CaseOfferCard extends StatelessWidget {
  final CaseOffer offer;
  final VoidCallback onTap;

  const CaseOfferCard({
    super.key,
    required this.offer,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFBFBFBF),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  offer.caseType,
                  style: const TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.goldLight,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    offer.status,
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'المحامي المقدم: ${offer.lawyerName}',
              style: const TextStyle(
                fontFamily: 'Almarai',
                fontSize: 15,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'السعر المتوقع: ${offer.expectedPrice}  ',
              style: const TextStyle(
                fontFamily: 'Almarai',
                fontSize: 15,
                color: Color(0xFF767676),
              ),
            ),
            Text(
              'الرسالة: ${offer.message}  ',
              style: const TextStyle(
                fontFamily: 'Almarai',
                fontSize: 15,
                color: Color(0xFF767676),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
