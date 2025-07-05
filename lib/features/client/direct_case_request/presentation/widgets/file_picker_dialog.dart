import 'package:flutter/material.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import '../controllers/direct_case_request_controller.dart';

void showFilePickerDialog(
  BuildContext context, {
  required Function(AttachmentType) onSelectFileType,
}) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'اختر نوع الملف',
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFileTypeOption(
                  context,
                  icon: Icons.image,
                  label: 'صورة',
                  onTap: () {
                    Navigator.pop(context);
                    onSelectFileType(AttachmentType.image);
                  },
                ),
                _buildFileTypeOption(
                  context,
                  icon: Icons.insert_drive_file,
                  label: 'مستند',
                  onTap: () {
                    Navigator.pop(context);
                    onSelectFileType(AttachmentType.document);
                  },
                ),
                _buildFileTypeOption(
                  context,
                  icon: Icons.mic,
                  label: 'تسجيل صوتي',
                  onTap: () {
                    Navigator.pop(context);
                    onSelectFileType(AttachmentType.audio);
                  },
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildFileTypeOption(
  BuildContext context, {
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: AppColors.primary,
            size: 30,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Almarai',
            fontSize: 14,
            color: AppColors.primary,
          ),
        ),
      ],
    ),
  );
}
