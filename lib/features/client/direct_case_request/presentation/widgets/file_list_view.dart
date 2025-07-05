import 'package:flutter/material.dart';
import 'package:nahkum/core/utils/app_colors.dart'; 
import 'dart:io';
import 'package:path/path.dart' as path;

class FileListView extends StatelessWidget {
  final List<File> selectedFiles;
  final Function(int) onRemove;

  const FileListView({
    super.key,
    required this.selectedFiles,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'الملفات المرفقة',
          style: TextStyle(
            fontFamily: 'Almarai',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: selectedFiles.length,
          itemBuilder: (context, index) {
            final file = selectedFiles[index];
            final fileName = path.basename(file.path);
            final extension = path.extension(file.path).toLowerCase();

            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.red,
                      size: 20,
                    ),
                    onPressed: () => onRemove(index),
                  ),
                  Expanded(
                    child: Text(
                      fileName,
                      style: const TextStyle(
                        fontFamily: 'Almarai',
                        fontSize: 13,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _getFileIcon(extension),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _getFileIcon(String extension) {
    IconData iconData;
    Color iconColor;

    if (['.jpg', '.jpeg', '.png', '.gif'].contains(extension)) {
      iconData = Icons.image;
      iconColor = Colors.blue;
    } else if (['.pdf', '.doc', '.docx', '.txt'].contains(extension)) {
      iconData = Icons.description;
      iconColor = Colors.red;
    } else if (['.mp3', '.wav', '.m4a'].contains(extension)) {
      iconData = Icons.audiotrack;
      iconColor = Colors.orange;
    } else {
      iconData = Icons.insert_drive_file;
      iconColor = Colors.grey;
    }

    return Icon(iconData, color: iconColor, size: 24);
  }
}
