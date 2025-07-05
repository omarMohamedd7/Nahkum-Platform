import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/repo/auth_repo.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/cache_helper.dart';
import 'package:nahkum/core/widgets/custom_image_picker_dialog.dart';
import 'package:nahkum/features/onboarding/data/models/user_role.dart';
import 'package:nahkum/features/onboarding/presentation/controllers/onboarding_controller.dart';

class RegisterController extends GetxController {
  AuthRepo authRepo = AuthRepo();

  final Rx<UserRole> userRole =
      Rx(Get.find<OnboardingController>().selectedRole.value!);

  final registerFormKey = GlobalKey<FormState>();

  late TextEditingController usernameController,
      emailRegisterController,
      passwordRegisterController,
      confirmPasswordController;
  late TextEditingController phoneController;

  late TextEditingController consultationFeeController;
  late TextEditingController judgeSpecializationController;
  late TextEditingController courtNameController;

  final isLoading = false.obs;
  final acceptTerms = false.obs;
  final selectedImage = Rx<File?>(null);

  final ImagePicker _picker = ImagePicker();

  final selectedSpecialization = RxString('');
  final selectedCity = RxString('');

  final Map<String, String> specializationOptions = {
    'قانون الأسرة': 'Family Law',
    'القانون المدني': 'Civil Law',
    'القانون الجنائي': 'Criminal Law',
    'القانون التجاري': 'Commercial Law',
    'القانون الدولي': 'International Law',
  };

  List<String> get specializations => specializationOptions.keys.toList();

  final List<String> cities = [
    'دمشق',
    'حلب',
    'حماه',
    'اللاذقية',
    'دير الزور',
  ];

  @override
  void onInit() {
    super.onInit();
    _initControllers();
  }

  void _initControllers() {
    usernameController = TextEditingController();
    emailRegisterController = TextEditingController();
    passwordRegisterController = TextEditingController();
    confirmPasswordController = TextEditingController();

    phoneController = TextEditingController();

    consultationFeeController = TextEditingController();
    judgeSpecializationController = TextEditingController();
    courtNameController = TextEditingController();
  }

  void setSpecialization(String? value) {
    if (value != null) {
      selectedSpecialization.value = value;
    }
  }

  void setCity(String? value) {
    if (value != null) {
      selectedCity.value = value;
    }
  }

  @override
  void onClose() {
    super.onClose();
    _disposeControllers();
  }

  void _disposeControllers() {
    usernameController.dispose();
    emailRegisterController.dispose();
    passwordRegisterController.dispose();
    confirmPasswordController.dispose();
    phoneController.dispose();
    consultationFeeController.dispose();
    judgeSpecializationController.dispose();
    courtNameController.dispose();
  }

  void setTermsAcceptance(bool value) {
    acceptTerms.value = value;
  }

  Future<void> register() async {
    if (!registerFormKey.currentState!.validate() || !acceptTerms.value) return;
    isLoading.value = true;

    String? backendSpecialization;
    if (selectedSpecialization.value.isNotEmpty) {
      backendSpecialization =
          specializationOptions[selectedSpecialization.value];
    }

    // Get FCM token from cache
    final fcmToken = cache.read(CacheHelper.fcmToken);

    final result = await authRepo.register(
      name: usernameController.text,
      email: emailRegisterController.text,
      password: passwordRegisterController.text,
      phone: phoneController.text,
      city: selectedCity.value,
      specialization: backendSpecialization,
      consultFee: consultationFeeController.text,
      role: userRole.value.name,
      profileImagePath: selectedImage.value?.path ?? '',
      fcmToken: fcmToken,
    );

    if (result is DataSuccess) {
      Get.snackbar(
        'تحقق من البريد الإلكتروني',
        'تم إرسال رمز التحقق إلى بريدك الإلكتروني',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );

      Get.toNamed(
        Routes.OTP_VERIFICATION,
        arguments: {'email': emailRegisterController.text},
      );
    } else if (result is DataFailed) {
      Get.snackbar(
        'خطأ',
        result.error.toString(),
        backgroundColor: Colors.red,
      );
    }
    isLoading.value = false;
  }

  void showMessage(String message, {bool isError = false}) {
    Get.snackbar(
      isError ? 'خطأ' : 'نجاح',
      message,
      backgroundColor: isError ? Colors.red : Colors.green,
      colorText: Colors.white,
    );
  }

  Future<void> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      showMessage('فشل في اختيار الصورة: $e', isError: true);
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      showMessage('فشل في التقاط الصورة: $e', isError: true);
    }
  }

  void showImageSourceDialog() {
    Get.dialog(CustomImagePickerDialog(
      pickImageFromGallery: pickImageFromGallery,
      pickImageFromCamera: pickImageFromCamera,
    ));
  }
}
