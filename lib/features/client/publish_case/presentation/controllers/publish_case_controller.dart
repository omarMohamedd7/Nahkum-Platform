import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/data/failure.dart';
import 'package:nahkum/core/repo/client_repo.dart';
import 'package:nahkum/core/utils/injector.dart';
import 'package:nahkum/core/utils/cache_helper.dart';
import 'package:nahkum/core/routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';
import 'package:file_picker/file_picker.dart';

enum AttachmentType { image, document, audio }

class PublishCaseController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final caseDescriptionController = TextEditingController();

  final RxString caseType = ''.obs;
  final RxString targetCity = ''.obs;
  final RxList<File> selectedFiles = <File>[].obs;
  final RxBool isSubmitting = false.obs;

  final ClientRepo _clientRepo = injector();

  // Map of case types with Arabic display text and corresponding backend values
  final Map<String, String> caseTypesMap = {
    'قانون الأسرة': 'Family Law',
    'القانون المدني': 'Civil Law',
    'القانون الجنائي': 'Criminal Law',
    'القانون التجاري': 'Commercial Law',
    'القانون الدولي': 'International Law',
  };

  // List of case types for display in the UI
  List<String> get caseTypes => caseTypesMap.keys.toList();

  final List<String> cities = [
    'دمشق',
    'حلب',
    'حماه',
    'اللاذقية',
    'دير الزور',
  ];

  // Selected case type in backend format
  String get selectedCaseTypeBackendValue {
    return caseTypesMap[caseType.value] ?? '';
  }

  @override
  void onInit() {
    super.onInit();
    print('PublishCaseController initialized');
  }

  @override
  void onClose() {
    caseDescriptionController.dispose();
    super.onClose();
  }

  void setCaseType(String? value) {
    caseType.value = value ?? '';
    print('Case type set to: ${caseType.value}');
    print('Backend case type value: ${selectedCaseTypeBackendValue}');
  }

  void setTargetCity(String? value) {
    targetCity.value = value ?? '';
    print('Target city set to: ${targetCity.value}');
  }

  Future<void> handleFilePickerSelect(AttachmentType fileType) async {
    switch (fileType) {
      case AttachmentType.image:
        await _pickImageFiles();
        break;
      case AttachmentType.document:
        await _pickDocumentFiles();
        break;
      case AttachmentType.audio:
        _showAudioNotSupportedMessage();
        break;
    }
  }

  Future<void> _pickImageFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null && result.paths.isNotEmpty) {
        final files = result.paths
            .where((path) => path != null)
            .map((path) => File(path!))
            .toList();
        selectedFiles.addAll(files);
        print('Selected ${files.length} image files');
      }
    } catch (e) {
      print('Error picking image files: $e');
      showErrorMessage('حدث خطأ أثناء اختيار الصور: $e');
    }
  }

  Future<void> _pickDocumentFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: true,
      );

      if (result != null && result.paths.isNotEmpty) {
        final files = result.paths
            .where((path) => path != null)
            .map((path) => File(path!))
            .toList();
        selectedFiles.addAll(files);
        print('Selected ${files.length} document files');
      }
    } catch (e) {
      print('Error picking document files: $e');
      showErrorMessage('حدث خطأ أثناء اختيار المستندات: $e');
    }
  }

  void _showAudioNotSupportedMessage() {
    Get.snackbar(
      'غير مدعوم',
      'ملفات الصوت غير مدعومة حالياً',
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void showErrorMessage(String message) {
    Get.snackbar(
      'خطأ',
      message,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
    );
  }

  void removeFile(int index) {
    if (index >= 0 && index < selectedFiles.length) {
      selectedFiles.removeAt(index);
      print(
          'Removed file at index $index, ${selectedFiles.length} files remaining');
    }
  }

  Future<void> submitForm() async {
    print('Submit form called');

    if (formKey.currentState?.validate() == true) {
      if (caseType.value.isEmpty) {
        showErrorMessage('الرجاء اختيار نوع القضية');
        return;
      }

      if (targetCity.value.isEmpty) {
        showErrorMessage('الرجاء اختيار المدينة المستهدفة');
        return;
      }

      // print('Form validated, submitting case');
      // print('Case type (Arabic): ${caseType.value}');
      // print('Case type (Backend): ${selectedCaseTypeBackendValue}');
      // print('Description: ${caseDescriptionController.text}');
      // print('City: ${targetCity.value}');

      // isSubmitting.value = true;

      // try {
      //   // Direct API call for debugging
      //   try {
      //     final dioClient = dio.Dio();
      //     dioClient.options.headers = {
      //       'Accept': 'application/json',
      //       'Content-Type': 'application/json',
      //     };

      //     // Add auth token if available
      //     final token = GetStorage().read(CacheHelper.token);
      //     if (token != null && token.isNotEmpty) {
      //       dioClient.options.headers['Authorization'] = 'Bearer $token';
      //       print('Using token: $token');
      //     }

      //     final url = 'http://192.168.1.4:8000/api/published-cases';
      //     print('Sending request to: $url');

      //     final data = {
      //       'case_type': selectedCaseTypeBackendValue,
      //       'description': caseDescriptionController.text,
      //       'target_city': targetCity.value,
      //     };
      //     print('Request data: $data');

      //     final response = await dioClient.post(url, data: data);

      //     print('Response status code: ${response.statusCode}');
      //     print('Response data: ${response.data}');

      //     if (response.statusCode == 200 || response.statusCode == 201) {
      //       Get.snackbar(
      //         'تم',
      //         'تم نشر القضية بنجاح',
      //         backgroundColor: Colors.green,
      //         colorText: Colors.white,
      //         snackPosition: SnackPosition.BOTTOM,
      //       );
      //       Get.offAllNamed(AppPages.homeRoute());
      //     } else {
      //       showErrorMessage(
      //           'فشل في إرسال البيانات. رمز الحالة: ${response.statusCode}');
      //     }
      //   } catch (dioError) {
      //     print('Direct API call error: $dioError');
      //     if (dioError is dio.DioException) {
      //       print('DioError type: ${dioError.type}');
      //       print('DioError message: ${dioError.message}');
      //       print('DioError response: ${dioError.response?.data}');
      //       print('DioError status code: ${dioError.response?.statusCode}');

      //       String errorMessage = 'فشل في إرسال البيانات';
      //       if (dioError.response?.data != null) {
      //         if (dioError.response!.data is Map) {
      //           final errorData = dioError.response!.data as Map;
      //           if (errorData.containsKey('message')) {
      //             errorMessage += ': ${errorData['message']}';
      //           } else if (errorData.containsKey('error')) {
      //             errorMessage += ': ${errorData['error']}';
      //           }
      //         }
      //       }
      //       showErrorMessage(errorMessage);
      //     } else {
      //       showErrorMessage('فشل في إرسال البيانات: $dioError');
      //     }
      //   }

      //   // Using repository (keep this code)
      final response = await _clientRepo.publishCase(
        caseType: selectedCaseTypeBackendValue,
        description: caseDescriptionController.text,
        city: targetCity.value,
      );

      if (response is DataSuccess) {
        print('Case published successfully: ${response.data}');
        Get.snackbar(
          'تم',
          'تم نشر القضية بنجاح',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        Get.offAllNamed(AppPages.homeRoute());
      } else if (response is DataFailed) {
        print('Failed to publish case: ${response.error?.data}');
        print('Error status code: ${response.error?.statusCode}');

        String errorMessage = 'فشل في إرسال البيانات';
        if (response.error?.data != null) {
          errorMessage += ': ${response.error?.data}';
        }
        showErrorMessage(errorMessage);
      }
      // } catch (e) {
      //   print('Exception during submission: $e');
      //   showErrorMessage('حدث خطأ أثناء الإرسال: $e');
      // } finally {
      //   isSubmitting.value = false;
      // }
      // } else {
      //   print('Form validation failed');
      // }
    }
  }

  void goBack() {
    Get.back();
  }
}
