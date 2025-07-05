import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/utils/app_colors.dart'; 
import 'dart:io';
import 'file_list_view.dart';

class FileUploadSection extends StatelessWidget {
  final RxList<File> selectedFiles;
  final VoidCallback onUploadTap;
  final Function(int) onRemoveFile;

  const FileUploadSection({
    super.key,
    required this.selectedFiles,
    required this.onUploadTap,
    required this.onRemoveFile,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      color: AppColors.textSecondary,
      strokeWidth: 1,
      dashPattern: const [8, 4],
      borderType: BorderType.RRect,
      radius: const Radius.circular(8),
      padding: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFC8A45D).withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: onUploadTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'ارفع ملفات القضية',
                    style: TextStyle(
                      fontFamily: 'Almarai',
                      fontSize: 14,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.upload_file,
                    color: Colors.grey[700],
                    size: 20,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'مستندات رسمية، تقارير، شكاوى صور وثائق، إثباتات، صور شخصية, ملفات صوتية',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Almarai',
                fontSize: 11,
                color: Color(0xFF777777),
              ),
            ),
            Obx(() {
              if (selectedFiles.isNotEmpty) {
                return Column(
                  children: [
                    const SizedBox(height: 16),
                    FileListView(
                      selectedFiles: selectedFiles.toList(),
                      onRemove: onRemoveFile,
                    ),
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            }),
          ],
        ),
      ),
    );
  }
}
