import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/utils/cache_helper.dart';
import 'package:nahkum/core/widgets/custom_image_picker_dialog.dart';
import 'package:nahkum/features/profile/data/models/profile_model.dart';
import 'package:nahkum/features/profile/data/repo/profile_repo.dart';

class ProfileController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  void setProfileControllers() {
    emailController.text = profile!.email;
    nameController.text = profile!.name;
  }

  ProfileModel? profile;
  final ProfileRepo _profileRepo = ProfileRepo();
  final isLoading = false.obs;

  Future<void> getProfile() async {
    isLoading(true);
    final dataState = await _profileRepo.getProfile();
    if (dataState is DataSuccess) {
      profile = dataState.data!;
      setProfileControllers();
      cache.write(CacheHelper.user, dataState.data!.toJson());
    } else if (dataState is DataFailed) {
      showMessage(dataState.error!.data.toString());
    }
    isLoading(false);
  }

  @override
  void onInit() {
    getProfile();
    super.onInit();
  }

  final isEditLoading = false.obs;
  Rx<XFile?> imageToEdit = Rx(null);
  Future<void> editProfile() async {
    isEditLoading(true);
    final dataState = await _profileRepo.editProfile(
      name: nameController.text,
      email: emailController.text,
      imageToEdit: imageToEdit.value,
    );
    if (dataState is DataSuccess) {
      cache.write(CacheHelper.user, dataState.data!.toJson());
      showMessage('تم التعديل بنجاح', isError: false);
    } else if (dataState is DataFailed) {
      showMessage(dataState.error!.data.toString(), isError: true);
    }
    isEditLoading(false);
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
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (pickedFile != null) {
        imageToEdit.value = XFile(pickedFile.path);
      }
    } catch (e) {
      showMessage('فشل في اختيار الصورة: $e', isError: true);
    }
  }

  Future<void> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 800,
      );

      if (pickedFile != null) {
        imageToEdit.value = XFile(pickedFile.path);
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
