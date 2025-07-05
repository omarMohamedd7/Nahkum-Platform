import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nahkum/core/models/case.dart';
import 'package:nahkum/core/utils/app_colors.dart';

class CaseCard extends StatelessWidget {
  final Case caseItem;
  final VoidCallback onTap;

  const CaseCard({
    super.key,
    required this.caseItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Extract lawyer name from lawyerName field or fall back to lawyerId
    final String lawyerName =
        (caseItem.lawyerName != null && caseItem.lawyerName!.isNotEmpty)
            ? caseItem.lawyerName!
            : 'غير محدد';

    // Format the description to show a preview
    final String descriptionPreview = caseItem.description.isNotEmpty
        ? (caseItem.description.length > 100
            ? '${caseItem.description.substring(0, 100)}...'
            : caseItem.description)
        : 'لا يوجد وصف';

    // Format date if available
    final String dateText = caseItem.createdAt != null
        ? _formatDate(caseItem.createdAt!)
        : _formatDate(DateTime.now());

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildStatusChip(caseItem.status),
                  Text(
                    dateText,
                    style: const TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                caseItem.caseType.isNotEmpty
                    ? caseItem.caseType
                    : caseItem.title,
                style: const TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                descriptionPreview,
                style: const TextStyle(
                  fontFamily: 'Almarai',
                  fontSize: 14,
                  color: Colors.black54,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 14,
                      color: Colors.grey,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'المحامي: $lawyerName',
                        style: const TextStyle(
                          fontFamily: 'Almarai',
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    Color textColor;

    // Normalize status to lowercase for comparison
    final normalizedStatus = status.toLowerCase();

    if (normalizedStatus.contains('بانتظار') ||
        normalizedStatus.contains('pending') ||
        normalizedStatus == 'نشط' ||
        normalizedStatus == 'active') {
      chipColor = AppColors.goldLight;
      textColor = Colors.white;
    } else if (normalizedStatus.contains('موافق') ||
        normalizedStatus.contains('approved') ||
        normalizedStatus.contains('accepted')) {
      chipColor = Colors.green;
      textColor = Colors.white;
    } else if (normalizedStatus.contains('مغلق') ||
        normalizedStatus.contains('closed')) {
      chipColor = AppColors.error;
      textColor = Colors.white;
    } else if (normalizedStatus.contains('مرفوض') ||
        normalizedStatus.contains('rejected')) {
      chipColor = const Color(0xFFFFDCDC);
      textColor = const Color(0xFFE53935);
    } else {
      chipColor = const Color(0xFFE0E0E0);
      textColor = const Color(0xFF757575);
    }

    // Display the status as is, since we're now translating it in the controller
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontFamily: 'Almarai',
          fontSize: 12,
          color: textColor,
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('yyyy/MM/dd').format(date);
  }
}
