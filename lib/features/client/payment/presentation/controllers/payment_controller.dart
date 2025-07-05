import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/features/client/payment/services/payment_service.dart';
import 'dart:math';

class PaymentController extends GetxController {
  final PaymentService _paymentService = PaymentService();

  final formKey = GlobalKey<FormState>();
  final cardNumberController = TextEditingController();
  final cardHolderController = TextEditingController();
  final expiryDateController = TextEditingController();
  final cvvController = TextEditingController();

  final isProcessing = false.obs;
  final selectedPaymentMethod = 'credit_card'.obs;

  String lawyerId = '1'; // Default to 1 to ensure it's never empty
  double amount = 250.0;
  String consultationType = '';
  String description = '';
  String preferredDate = '';
  String preferredTime = '';

  @override
  void onInit() {
    super.onInit();
    _initializeFromArguments();
  }

  void _initializeFromArguments() {
    try {
      final args = Get.arguments;
      print('Payment arguments received:');
      print(args);

      if (args == null || args.isEmpty) {
        print('WARNING: No arguments provided to payment screen');
        // Set default values for testing - REMOVE IN PRODUCTION
        lawyerId = '1'; // Default lawyer ID for testing
        amount = 250.0; // Default amount
        consultationType = 'استشارة قانونية'; // Default consultation type
        description = 'استشارة قانونية عامة';
        preferredDate = '2023-10-15';
        preferredTime = '14:00';

        print('Set default values for testing:');
        print('lawyerId: $lawyerId');
        print('amount: $amount');

        return;
      }

      // Extract and validate lawyerId
      var extractedLawyerId = args['lawyerId']?.toString() ?? '';
      if (extractedLawyerId.isEmpty) {
        print('lawyerId is empty in arguments, setting default value');
        extractedLawyerId = '1'; // Set default value if empty
      }
      lawyerId = extractedLawyerId;
      print('Set lawyerId to: $lawyerId (type: ${lawyerId.runtimeType})');

      // Convert amount to double if it's a string or int
      if (args['amount'] is String) {
        amount = double.tryParse(args['amount']) ?? 0.0;
      } else if (args['amount'] is int) {
        amount = (args['amount'] as int).toDouble();
      } else {
        amount = args['amount'] ?? 0.0;
      }

      // Set default amount if invalid
      if (amount <= 0) {
        print('Amount is invalid, setting default value');
        amount = 250.0; // Default amount
      }

      consultationType =
          args['consultationType']?.toString() ?? 'استشارة قانونية';
      description = args['description']?.toString() ?? 'استشارة قانونية عامة';
      preferredDate = args['preferredDate']?.toString() ?? '2023-10-15';
      preferredTime = args['preferredTime']?.toString() ?? '14:00';

      // Debug log
      print('Initialized payment controller with:');
      print('lawyerId: $lawyerId');
      print('amount: $amount');
    } catch (e) {
      print('Error initializing payment controller: $e');
      print('Stack trace: ${StackTrace.current}');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء تحميل بيانات الاستشارة: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  void onClose() {
    cardNumberController.dispose();
    cardHolderController.dispose();
    expiryDateController.dispose();
    cvvController.dispose();
    super.onClose();
  }

  void setPaymentMethod(String method) {
    selectedPaymentMethod.value = method;
  }

  void processPayment() {
    print('Payment button clicked');

    if (!_validateRequiredFields()) {
      print('Required fields validation failed');
      return;
    }

    if (formKey.currentState!.validate()) {
      print('Form validation passed, starting payment process');
      isProcessing.value = true;
      _processPaymentAsync();
    } else {
      print('Form validation failed');
    }
  }

  bool _validateRequiredFields() {
    print('Validating required fields:');
    print('lawyerId: "$lawyerId"');
    print('amount: $amount');

    // If lawyerId is empty, set a default value for testing
    if (lawyerId.isEmpty) {
      print('Setting default lawyer ID for testing');
      lawyerId = '1';
      print('New lawyerId: $lawyerId');
    }

    if (amount <= 0) {
      print('ERROR: amount is invalid: $amount');
      Get.snackbar(
        'خطأ',
        'المبلغ غير صحيح',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    print('All required fields are valid');
    return true;
  }

  Future<void> _processPaymentAsync() async {
    print('Starting _processPaymentAsync');
    try {
      // Debug log
      print('Processing payment with:');
      print('lawyerId: $lawyerId (type: ${lawyerId.runtimeType})');

      // Step 1: Create consultation request first - only lawyer_id is required
      print('Step 1: Creating consultation request');
      final consultationRequestId =
          await _paymentService.createConsultationRequest(
        lawyerId: lawyerId,
        // Optional parameters - not required by the backend
        consultationType: consultationType,
        description: description,
        date: preferredDate,
        time: preferredTime,
      );

      if (consultationRequestId == null) {
        print('ERROR: Failed to get consultation request ID');
        Get.snackbar(
          'خطأ',
          'فشل في إنشاء طلب الاستشارة',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isProcessing.value = false;
        return;
      }

      print('تم إنشاء طلب استشارة برقم: $consultationRequestId');

      // Step 2: Process payment with the consultation request ID
      print('Step 2: Processing payment');
      final cleanCardNumber = cardNumberController.text.replaceAll(' ', '');
      print(
          'Card number (cleaned): ${cleanCardNumber.isNotEmpty ? cleanCardNumber.substring(0, min(4, cleanCardNumber.length)) : ""}****');
      print('Card holder: ${cardHolderController.text}');
      print('Expiry date: ${expiryDateController.text}');

      // Generate a unique transaction ID
      final transactionId = _generateTransactionId();
      print('Transaction ID: $transactionId');

      print('Calling payment service with:');
      print('consultationRequestId: $consultationRequestId');
      print('paymentMethod: ${selectedPaymentMethod.value}');

      final result = await _paymentService.processPayment(
        offerId: '', // Not needed when using consultationRequestId
        amount: amount,
        paymentMethod: selectedPaymentMethod.value,
        consultationRequestId: consultationRequestId,
        cardNumber: cleanCardNumber,
        cardHolder: cardHolderController.text,
        expiryDate: expiryDateController.text,
        cvv: cvvController.text,
        transactionId: transactionId, // Pass the transaction ID
      );

      print('Payment result: $result');

      if (result) {
        print('Payment successful, navigating to success screen');
        Get.offNamed(
          Routes.PAYMENT_SUCCESS,
          arguments: {
            'amount': amount,
            'transactionId': transactionId,
          },
        );
      } else {
        print('Payment failed');
        Get.snackbar(
          'خطأ',
          'فشل في إتمام عملية الدفع',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('ERROR in _processPaymentAsync: $e');
      print('Stack trace: ${StackTrace.current}');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء معالجة الدفع: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      print('Payment process completed');
      isProcessing.value = false;
    }
  }

  String _generateTransactionId() {
    return 'TRX-${DateTime.now().millisecondsSinceEpoch}';
  }

  String? validateCardNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال رقم البطاقة';
    }

    final cleanNumber = value.replaceAll(' ', '');

    if (cleanNumber.length != 16) {
      return 'رقم البطاقة يجب أن يكون 16 رقمًا';
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(cleanNumber)) {
      return 'رقم البطاقة يجب أن يحتوي على أرقام فقط';
    }

    return null;
  }

  String? validateCardHolder(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال اسم حامل البطاقة';
    }
    return null;
  }

  String? validateExpiryDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال تاريخ الانتهاء';
    }

    if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
      return 'الصيغة غير صحيحة (مثال: 12/25)';
    }

    try {
      final parts = value.split('/');
      final month = int.parse(parts[0]);
      final year = int.parse('20${parts[1]}');

      if (month < 1 || month > 12) {
        return 'الشهر غير صحيح (يجب أن يكون بين 01 و 12)';
      }

      final now = DateTime.now();
      final currentYear = now.year;
      final currentMonth = now.month;

      if (year < currentYear) {
        return 'البطاقة منتهية الصلاحية';
      }

      if (year == currentYear && month < currentMonth) {
        return 'البطاقة منتهية الصلاحية';
      }

      if (year > currentYear + 20) {
        return 'تاريخ انتهاء غير صالح';
      }
    } catch (e) {
      return 'تاريخ غير صالح';
    }

    return null;
  }

  String? validateCVV(String? value) {
    if (value == null || value.isEmpty) {
      return 'الرجاء إدخال رمز CVV';
    }
    if (value.length < 3) {
      return 'رمز CVV غير صحيح';
    }
    return null;
  }

  // Method to manually set lawyer ID - useful for testing
  void setLawyerId(String id) {
    print('Manually setting lawyer ID to: $id');
    lawyerId = id;
  }
}
