import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/widgets/custom_button.dart';
import 'package:nahkum/core/widgets/custom_text_field.dart';
import '../../../../../core/utils/form_validator.dart';
import '../controllers/direct_case_request_controller.dart';
import '../widgets/case_type_dropdown.dart';
import '../widgets/file_picker_dialog.dart';
import '../widgets/file_upload_section.dart';

class DirectCaseRequestView extends GetView<DirectCaseRequestController> {
  const DirectCaseRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: AppColors.screenBackground,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: controller.goBack,
          ),
          title: const Text(
            'طلب توكيل جديد',
            style: TextStyle(
              color: AppColors.primary,
              fontFamily: 'Almarai',
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
                      FileUploadSection(
                        selectedFiles: controller.selectedFiles,
                        onUploadTap: () => showFilePickerDialog(
                          context,
                          onSelectFileType: controller.handleFilePickerSelect,
                        ),
                        onRemoveFile: controller.removeFile,
                      ),
                      const SizedBox(height: 24),
                      const CaseTypeDropdown(),
                      const SizedBox(height: 16),
                      CustomTextField(
                        labelText: 'أسم المدعي',
                        hintText: 'أكتب اسم المدعي',
                        controller: controller.plaintiffNameController,
                        validator: FormValidators.validatePlaintiffName,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        labelText: 'أسم المدعي عليه',
                        hintText: 'أكتب اسم المدعي عليه',
                        controller: controller.defendantNameController,
                        validator: FormValidators.validateDefendantName,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        labelText: 'رقم القضية (اختياري)',
                        hintText: 'أكتب رقم القضية',
                        controller: controller.caseNumberController,
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        labelText: 'وصف القضية',
                        hintText: 'اشرح تفاصيل القضية',
                        controller: controller.caseDescriptionController,
                        validator: FormValidators.validateCaseDescription,
                      ),
                      const SizedBox(height: 32),
                      CustomButton(
                        text: 'إرسال الطلب',
                        onTap: controller.submitForm,
                        backgroundColor: AppColors.primary,
                        textColor: Colors.white,
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
            Obx(() {
              if (controller.isSubmitting.value) {
                return Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                    ),
                  ),
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
