import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/data/failure.dart';
import 'package:nahkum/core/repo/client_repo.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/injector.dart';
import 'package:file_picker/file_picker.dart';

// Local FileType enum for our app's UI
enum AttachmentType { image, document, audio }

class DirectCaseRequestController extends GetxController {
  final ClientRepo _clientRepo = injector();
  final formKey = GlobalKey<FormState>();
  final plaintiffNameController = TextEditingController();
  final defendantNameController = TextEditingController();
  final caseNumberController = TextEditingController();
  final caseDescriptionController = TextEditingController();

  final RxString caseType = ''.obs;
  final RxList<File> selectedFiles = <File>[].obs;
  final RxBool isSubmitting = false.obs;

  // Lawyer ID from arguments - stored as int
  int lawyerId = 0;

  @override
  void onInit() {
    super.onInit();

    print('DirectCaseRequestController: All arguments: ${Get.arguments}');

    // Get lawyer ID from arguments if available
    if (Get.arguments != null) {
      // Case 1: If arguments is a Map with lawyer_id key
      if (Get.arguments is Map && Get.arguments['lawyer_id'] != null) {
        var rawId = Get.arguments['lawyer_id'];
        print('DirectCaseRequestController: Using lawyer_id from map: $rawId');
        tryParseId(rawId);
      }
      // Case 2: If arguments is a Lawyer object
      else if (Get.arguments.runtimeType.toString().contains('Lawyer')) {
        print('DirectCaseRequestController: Arguments is a Lawyer object');
        try {
          var rawId = Get.arguments.id;
          print(
              'DirectCaseRequestController: Using id from Lawyer object: $rawId');
          tryParseId(rawId);
        } catch (e) {
          print('DirectCaseRequestController: Error accessing Lawyer.id: $e');
          lawyerId = 0;
        }
      }
      // Case 3: If arguments is directly the ID
      else {
        print('DirectCaseRequestController: Arguments might be direct ID');
        tryParseId(Get.arguments);
      }
    } else {
      print('DirectCaseRequestController: Get.arguments is null');
      lawyerId = 0;
    }

    // Final check - if we somehow still have null or invalid ID, set to 0
    if (lawyerId <= 0) {
      print('DirectCaseRequestController: Invalid lawyer ID, setting to 0');
      lawyerId = 0;
    }

    print('DirectCaseRequestController: Final lawyerId value: $lawyerId');
  }

  // Helper method to parse ID from various types
  void tryParseId(dynamic rawId) {
    try {
      if (rawId == null) {
        print('DirectCaseRequestController: ID is null');
        lawyerId = 0;
      } else if (rawId is int) {
        lawyerId = rawId;
      } else if (rawId is String) {
        lawyerId = int.parse(rawId);
      } else {
        lawyerId = int.parse(rawId.toString());
      }
      print('DirectCaseRequestController: Parsed ID: $lawyerId');
    } catch (e) {
      print('DirectCaseRequestController: Error parsing ID: $e');
      lawyerId = 0;
    }
  }

  @override
  void onClose() {
    plaintiffNameController.dispose();
    defendantNameController.dispose();
    caseNumberController.dispose();
    caseDescriptionController.dispose();
    super.onClose();
  }

  void setCaseType(String? type) {
    caseType.value = type ?? '';
  }

  void goBack() {
    Get.back();
  }

  Future<void> handleFilePickerSelect(AttachmentType fileType) async {
    switch (fileType) {
      case AttachmentType.image:
        await pickFiles();
        break;
      case AttachmentType.document:
        await pickDocuments();
        break;
      case AttachmentType.audio:
        showAudioNotSupportedMessage();
        break;
    }
  }

  Future<void> pickFiles() async {
    try {
      final picker = ImagePicker();
      final XFile? pickedFile = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        selectedFiles.add(File(pickedFile.path));
      }
    } catch (e) {
      final failure = FileFailure.uploadFailed();
      showErrorMessage(failure.message);
    }
  }

  Future<void> pickDocuments() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowedExtensions: ['pdf', 'doc', 'docx'],
      );

      if (result != null && result.files.single.path != null) {
        File file = File(result.files.single.path!);
        selectedFiles.add(file);
      }
    } catch (e) {
      final failure = FileFailure.uploadFailed();
      showErrorMessage(failure.message);
    }
  }

  void showAudioNotSupportedMessage() {
    Get.snackbar(
      'غير مدعوم',
      'سيتم دعم الملفات الصوتية قريباً',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void showErrorMessage(String message) {
    // Check if it's a duplicate request error
    final bool isDuplicateError = message.contains('أرسلت بالفعل طلبًا');

    Get.snackbar(
      isDuplicateError ? 'تنبيه' : 'خطأ',
      message,
      backgroundColor: isDuplicateError ? Colors.orange : Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(10),
      borderRadius: 10,
      icon: Icon(
        isDuplicateError ? Icons.warning_amber_rounded : Icons.error_outline,
        color: Colors.white,
      ),
    );
  }

  void removeFile(int index) {
    selectedFiles.removeAt(index);
  }

  Future<void> submitForm() async {
    if (formKey.currentState?.validate() == true) {
      if (lawyerId <= 0) {
        showErrorMessage('لم يتم تحديد المحامي، يرجى المحاولة مرة أخرى');
        return;
      }

      isSubmitting.value = true;
      print(
          'DirectCaseRequestController: Submitting form with lawyer_id: $lawyerId');

      try {
        final result = await _clientRepo.createDirectCaseRequest(
          lawyerId: lawyerId.toString(), // Convert to string for API call
          defendantName: defendantNameController.text,
          plaintiffName: plaintiffNameController.text,
          description: caseDescriptionController.text,
          attachment: selectedFiles.isNotEmpty ? selectedFiles.first : null,
        );

        if (result is DataSuccess) {
          Get.snackbar(
            'تم',
            'تم ارسال طلبك الى المحامي بانتظار الموافقة',
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );

          Get.offAllNamed(Routes.HOME);
        } else if (result is DataFailed) {
          final errorMessage = result.error.toString().toLowerCase();

          // Check if it's a duplicate request error
          if (errorMessage.contains('أرسلت بالفعل طلبًا') ||
              errorMessage.contains('already sent a request')) {
            showDuplicateRequestDialog();
          } else {
            showErrorMessage('فشل في إرسال الطلب: ${result.error}');
          }
          print('DirectCaseRequestController: Request failed: ${result.error}');
        }
      } catch (e) {
        showErrorMessage('حدث خطأ أثناء إرسال الطلب');
        print('DirectCaseRequestController: Error submitting case request: $e');
      } finally {
        isSubmitting.value = false;
      }
    }
  }

  // Show a dialog for duplicate case requests
  void showDuplicateRequestDialog() {
    Get.dialog(
      Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text(
            'طلب موجود بالفعل',
            style: TextStyle(
              fontFamily: 'Almarai',
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          content: const Text(
            'لقد أرسلت بالفعل طلبًا إلى هذا المحامي. يرجى انتظار رده على طلبك الحالي قبل إرسال طلب جديد.',
            style: TextStyle(
              fontFamily: 'Almarai',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Close dialog
                Get.offAllNamed(Routes.HOME); // Go back to home
              },
              child: const Text(
                'العودة للرئيسية',
                style: TextStyle(
                  fontFamily: 'Almarai',
                  color: Colors.orange,
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }
}
