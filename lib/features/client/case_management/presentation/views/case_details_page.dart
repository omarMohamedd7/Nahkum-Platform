import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/features/chat/data/models/contact_model.dart';
import 'package:nahkum/features/client/case_management/data/models/case_model.dart';
import 'package:nahkum/features/client/case_management/presentation/widgets/case_file_section.dart';
import 'package:nahkum/features/client/case_management/presentation/widgets/lawyer_info_card.dart'
    show LawyerInfoCard;
import 'package:nahkum/features/onboarding/data/models/user_role.dart';

class CaseDetailsPage extends StatelessWidget {
  final CasePreview caseItem;

  const CaseDetailsPage({
    super.key,
    required this.caseItem,
  });

  @override
  Widget build(BuildContext context) {
    final bool isApproved = caseItem.Status == 'موافق عليه';
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: AppColors.primary),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'تفاصيل القضية',
            style: TextStyle(
              color: AppColors.primary,
              fontFamily: 'Almarai',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC8A45D).withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.lightbulb_outline,
                              color: Color(0xFFC8A45D),
                              size: 20,
                            ),
                          ),
                          Positioned(
                            top: -2,
                            right: -2,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: Color(0xFFC8A45D),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'سيتم تفعيل زر المحادثة عند قبول المحامي لطلب التوكيل.',
                          style: TextStyle(
                            color: AppColors.textPrimary,
                            fontFamily: 'Almarai',
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          caseItem.caseType,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontFamily: 'Almarai',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFC8A45D).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        caseItem.Status,
                        style: const TextStyle(
                          color: Color(0xFFC8A45D),
                          fontFamily: 'Almarai',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 392,
                  height: 74,
                  child: LawyerInfoCard(
                    lawyerName: caseItem.lawyerName ?? 'غير معين',
                    lawyerImageUrl: 'assets/images/lawyer_profile.png',
                    customHeight: 74,
                  ),
                ),
                // const SizedBox(height: 24),
                // const CaseFileSection(
                //   title: 'ملفات القضية',
                //   fileCount: 'تم رفع أربع صور',
                // ),
                const SizedBox(height: 24),
                Text(
                  caseItem.description,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontFamily: 'Almarai',
                    fontSize: 16,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isApproved
                        ? AppColors.primary
                        : AppColors.primary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextButton(
                    onPressed: isApproved
                        ? () {
                            var contactModel = ContactModel(
                              id: int.tryParse(caseItem.userId.toString()) ?? 0,
                              name: caseItem.lawyerName.toString(),
                              role: UserRole.lawyer.name,
                              lastMessageDate: DateTime.now(),
                            );

                            Get.toNamed(Routes.CHAT_DETAIL, arguments: {
                              'contactModel': contactModel,
                            });
                          }
                        : null,
                    style: TextButton.styleFrom(
                      foregroundColor: isApproved
                          ? Colors.white
                          : Colors.white.withOpacity(0.3),
                    ),
                    child: const Text(
                      'محادثة',
                      style: TextStyle(
                        fontFamily: 'Almarai',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
