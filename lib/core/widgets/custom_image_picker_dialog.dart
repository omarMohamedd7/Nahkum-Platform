import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomImagePickerDialog extends StatelessWidget {
  const CustomImagePickerDialog({
    super.key,
    required this.pickImageFromGallery,
    required this.pickImageFromCamera,
  });

  final void Function() pickImageFromGallery;
  final void Function() pickImageFromCamera;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text(
        'اختر مصدر الصورة',
        textAlign: TextAlign.center,
        style: TextStyle(fontFamily: 'Almarai', fontWeight: FontWeight.bold),
      ),
      content: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('معرض الصور'),
              onTap: () {
                Get.back();
                pickImageFromGallery();
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('الكاميرا'),
              onTap: () {
                Get.back();
                pickImageFromCamera();
              },
            ),
          ],
        ),
      ),
    );
  }
}
