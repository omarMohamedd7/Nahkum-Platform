import 'package:flutter/material.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/features/lawer/data/models/case_model.dart';
import 'package:nahkum/features/lawer/data/models/published_case_client_model.dart';

class ClientCard extends StatelessWidget {
  final PublishedCaseClientModel client;
  final CaseModel? caseItem;
  final VoidCallback onTap;

  const ClientCard({
    super.key,
    required this.client,
    this.caseItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double fontSize = screenWidth < 360 ? 13 : 14;
    final double smallFontSize = screenWidth < 360 ? 11 : 12;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: screenWidth - 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFBFBFBF)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFEEE3CD),
                    shape: BoxShape.circle,
                  ),
                  child: (client.image ?? '').isNotEmpty
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: Image.network(
                            client.image!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(
                                Icons.person,
                                color: AppColors.gold,
                                size: 24,
                              );
                            },
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          color: AppColors.gold,
                          size: 24,
                        ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          children: [
                            const Text(
                              'اسم الموكل: ',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF181E3C),
                              ),
                            ),
                            Text(
                              client.name,
                              style: TextStyle(
                                fontSize: fontSize,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Almarai',
                                color: const Color(0xFF181E3C),
                              ),
                              textAlign: TextAlign.right,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (caseItem != null) ...[
                        Row(
                          children: [
                            const Text(
                              'نوع القضية: ',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF181E3C),
                              ),
                            ),
                            Text(
                              caseItem!.caseType,
                              style: TextStyle(
                                fontSize: smallFontSize,
                                fontFamily: 'Almarai',
                                color: const Color(0xFF181E3C),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Text(
                              'رقم القضية: ',
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: 'Almarai',
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF181E3C),
                              ),
                            ),
                            Text(
                              caseItem!.caseNumber,
                              style: TextStyle(
                                fontSize: smallFontSize,
                                fontFamily: 'Almarai',
                                color: const Color(0xFF181E3C),
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Text(
                          'رقم الهاتف: ${client.phone}',
                          style: TextStyle(
                            fontSize: smallFontSize,
                            fontFamily: 'Almarai',
                            color: const Color(0xFF737373),
                          ),
                          textAlign: TextAlign.right,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'المدينة: ${client.city}',
                          style: TextStyle(
                            fontSize: smallFontSize,
                            fontFamily: 'Almarai',
                            color: const Color(0xFF737373),
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
