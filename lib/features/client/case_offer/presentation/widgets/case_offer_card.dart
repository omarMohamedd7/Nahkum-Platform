import 'package:flutter/material.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/features/client/case_management/data/models/case_offer.dart';

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
            color: AppColors.primary,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    offer.getArabicStatus(),
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: _getStatusTextColor(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'المحامي: ${offer.lawyerName}',
              style: const TextStyle(
                fontFamily: 'Almarai',
                fontSize: 15,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'السعر المتوقع: ${offer.expectedPrice} ريال',
              style: const TextStyle(
                fontFamily: 'Almarai',
                fontSize: 15,
                color: Color(0xFF767676),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              offer.message,
              style: const TextStyle(
                fontFamily: 'Almarai',
                fontSize: 14,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(80, 30),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  'تفاصيل',
                  style: TextStyle(
                    fontFamily: 'Almarai',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    switch (offer.status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFFFE4B8); // Light orange
      case 'approved':
        return const Color(0xFFCEF2DA); // Light green
      case 'rejected':
        return const Color(0xFFFFDCDC); // Light red
      default:
        return const Color(0xFFE0E0E0); // Default gray
    }
  }

  Color _getStatusTextColor() {
    switch (offer.status.toLowerCase()) {
      case 'pending':
        return const Color(0xFFD18E00); // Dark orange
      case 'approved':
        return const Color(0xFF4CAF50); // Dark green
      case 'rejected':
        return const Color(0xFFE53935); // Dark red
      default:
        return const Color(0xFF757575); // Default dark gray
    }
  }
}
