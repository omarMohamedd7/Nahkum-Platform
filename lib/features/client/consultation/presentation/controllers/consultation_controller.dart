import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/models/lawyer.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import '../../data/models/lawyer_model.dart';

class ConsultationController extends GetxController {
  final cardNameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final expiryDateController = TextEditingController();
  final ccvController = TextEditingController();

  final RxBool isLoading = false.obs;
  final Rx<LawyerModel?> selectedLawyer = Rx<LawyerModel?>(null);

  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null) {
      if (Get.arguments is Lawyer) {
        final coreLawyer = Get.arguments as Lawyer;
        selectedLawyer.value = LawyerModel(
          id: coreLawyer.id.toString(),
          name: coreLawyer.name,
          city: coreLawyer.location,
          description: coreLawyer.description,
          price: coreLawyer.consultationFee,
          imageUrl: coreLawyer.imageUrl,
          specialization: coreLawyer.specialization,
        );
      } else if (Get.arguments is LawyerModel) {
        selectedLawyer.value = Get.arguments;
      } else if (Get.arguments is Map) {
        final map = Get.arguments as Map;
        if (map.containsKey('lawyer')) {
          final lawyer = map['lawyer'];
          if (lawyer is Lawyer) {
            selectedLawyer.value = LawyerModel(
              id: lawyer.id.toString(),
              name: lawyer.name,
              city: lawyer.location,
              description: lawyer.description,
              price: lawyer.consultationFee,
              imageUrl: lawyer.imageUrl,
              specialization: lawyer.specialization,
            );
          }
        }
      }
    }

    if (selectedLawyer.value == null) {
      selectedLawyer.value = LawyerModel(
        id: '1',
        name: 'أسم المحامي',
        city: 'دمشق',
        description: 'هذا النص هو مثال لنص يمكن أن يستبدل...',
        price: 20.5,
        imageUrl: 'assets/images/person.svg',
        specialization: 'قانون مدني',
      );
    }
  }

  @override
  void onClose() {
    cardNameController.dispose();
    cardNumberController.dispose();
    expiryDateController.dispose();
    ccvController.dispose();
    super.onClose();
  }

  bool validateForm() {
    return cardNameController.text.isNotEmpty &&
        cardNumberController.text.isNotEmpty &&
        expiryDateController.text.isNotEmpty &&
        ccvController.text.isNotEmpty;
  }

  void submitRequest() async {
    if (!validateForm()) {
      Get.snackbar(
        'خطأ في البيانات',
        'الرجاء ملء جميع الحقول المطلوبة',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final dio = Dio();
      const clientId =
          'AUF2cMuydRvmCt5DX9T090H9rLTQLvJsC6nVt_Vrkl1n5O0q2maAcMuKPIpiR8935UB4bLQleIlkx_uK';
      const secret =
          'ECWSoG2zxoIoFqlIbSYp9pEhqqOLHUvwu1Nj4jXAPdlUjmS37VYibOhvyjJ0y8ddbneIZyDVgVRRd7oH';
      final basicAuth =
          'Basic ${base64Encode(utf8.encode('$clientId:$secret'))}';

      final tokenRes = await dio.post(
        'https://api-m.sandbox.paypal.com/v1/oauth2/token',
        data: {'grant_type': 'client_credentials'},
        options: Options(
          headers: {
            'Authorization': basicAuth,
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      final accessToken = tokenRes.data['access_token'];

      final lawyer = selectedLawyer.value!;
      final orderRes = await dio.post(
        'https://api-m.sandbox.paypal.com/v2/checkout/orders',
        data: {
          "intent": "CAPTURE",
          "purchase_units": [
            {
              "amount": {
                "currency_code": "USD",
                "value": lawyer.price.toString()
              }
            }
          ]
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      final orderId = orderRes.data['id'];

      final captureRes = await dio.post(
        'https://api-m.sandbox.paypal.com/v2/checkout/orders/$orderId/capture',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      isLoading.value = false;

      if (captureRes.statusCode == 201 || captureRes.statusCode == 200) {
        Get.offAllNamed(Routes.HOME);
        Get.snackbar(
          'تم الدفع',
          'تم تنفيذ الدفع بنجاح عبر PayPal',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        throw Exception('فشل تنفيذ عملية الدفع');
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        'فشل الدفع',
        'حدث خطأ أثناء تنفيذ الدفع',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
