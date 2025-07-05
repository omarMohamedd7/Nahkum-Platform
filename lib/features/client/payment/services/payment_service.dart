import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/repo/client_repo.dart';
import 'package:nahkum/core/utils/app_colors.dart';
import 'package:nahkum/core/utils/injector.dart';
import 'package:flutter/material.dart';

class PaymentService {
  final ClientRepo _clientRepo = injector();

  // Create a consultation request and return its ID
  Future<String?> createConsultationRequest({
    required String lawyerId,
    // These parameters are not required by the backend API
    String? consultationType,
    String? description,
    String? date,
    String? time,
  }) async {
    try {
      // Ensure lawyer_id is properly formatted
      // Some APIs expect integers for IDs, so try to parse it if needed
      final formattedLawyerId = int.tryParse(lawyerId) ?? lawyerId;

      final Map<String, dynamic> consultationData = {
        'lawyer_id': formattedLawyerId,
        // The backend only requires lawyer_id, but we can send additional data if needed
        if (consultationType != null && consultationType.isNotEmpty)
          'consultation_type': consultationType,
        if (description != null && description.isNotEmpty)
          'description': description,
        if (date != null && date.isNotEmpty) 'preferred_date': date,
        if (time != null && time.isNotEmpty) 'preferred_time': time,
      };

      // Debug log
      print('Creating consultation request with data:');
      print('lawyer_id type: ${formattedLawyerId.runtimeType}');
      print('lawyer_id value: $formattedLawyerId');
      print(consultationData);

      final result = await _clientRepo.requestConsultation(consultationData);

      // Debug log
      print('Consultation request result type: ${result.runtimeType}');
      if (result is DataSuccess) {
        // The backend returns a response with success, message, and data fields
        // We need to access the raw response data, not just the message
        final rawResponse = result.data;
        print('Consultation request successful: ${rawResponse}');

        // Try to extract the consultation ID from the raw response
        if (result.data is Map<String, dynamic>) {
          final responseMap = result.data as Map<String, dynamic>;

          // Check if there's a data field with an ID
          if (responseMap.containsKey('data') && responseMap['data'] is Map) {
            final dataMap = responseMap['data'] as Map;
            if (dataMap.containsKey('id')) {
              final consultationId = dataMap['id'].toString();
              print('Extracted consultation ID: $consultationId');
              return consultationId;
            }
          }

          // If we couldn't extract the ID, try to get it from the message
          if (responseMap.containsKey('message')) {
            return responseMap['message'].toString();
          }
        } else if (result.data != null) {
          // If it's a MessageModel, just return the message
          return result.data?.message;
        }
      } else if (result is DataFailed) {
        print('Consultation request failed: ${result.error}');
      }

      // If we couldn't extract an ID, show an error
      Get.snackbar(
        'خطأ',
        'فشل في إنشاء طلب الاستشارة',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    } catch (e) {
      print('Error creating consultation request: $e');
      Get.snackbar(
        'خطأ',
        'حدث خطأ أثناء إنشاء طلب الاستشارة: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return null;
    }
  }

  Future<bool> processPayment({
    required String offerId,
    required double amount,
    required String paymentMethod,
    String? consultationRequestId,
    String? cardNumber,
    String? cardHolder,
    String? expiryDate,
    String? cvv,
    String? transactionId,
  }) async {
    print('PaymentService.processPayment called with:');
    print('consultationRequestId: $consultationRequestId');
    print('paymentMethod: $paymentMethod');
    print('amount: $amount');

    try {
      final cleanCardNumber = cardNumber?.replaceAll(' ', '');
      final generatedTransactionId = transactionId ?? _generateTransactionId();

      final Map<String, dynamic> paymentData = {
        'consultation_request_id': consultationRequestId ?? offerId,
        'payment_method': paymentMethod,
        'transaction_id': generatedTransactionId,
        'amount': amount,
        'status': 'completed',
        if (cleanCardNumber != null) 'card_number': cleanCardNumber,
        if (cardHolder != null) 'card_holder': cardHolder,
        if (expiryDate != null) 'expiry_date': expiryDate,
        if (cvv != null) 'cvv': cvv,
      };

      // Debug log
      print('Processing payment with data:');
      print(paymentData);

      print('Calling ClientRepo.createPayment...');
      final result = await _clientRepo.createPayment(paymentData);
      print('ClientRepo.createPayment returned: ${result.runtimeType}');

      if (result is DataSuccess) {
        print('Payment successful: ${result.data?.message}');
        Get.snackbar(
          'تم الدفع بنجاح',
          'تمت عملية الدفع بنجاح وتم تحديث حالة الطلب',
          backgroundColor: AppColors.goldDark,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          margin: const EdgeInsets.all(10),
          borderRadius: 8,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        );
        return true;
      } else if (result is DataFailed) {
        print('Payment failed: ${result.error}');
        String errorMessage = 'حدث خطأ أثناء عملية الدفع';
        if (result.error is DioException) {
          final dioError = result.error as DioException;
          print('DioError type: ${dioError.type}');
          print('DioError message: ${dioError.message}');
          print('DioError response: ${dioError.response?.data}');

          switch (dioError.type) {
            case DioExceptionType.connectionTimeout:
            case DioExceptionType.sendTimeout:
            case DioExceptionType.receiveTimeout:
              errorMessage =
                  'فشل الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى';
              break;
            case DioExceptionType.badResponse:
              if (dioError.response?.statusCode == 401) {
                errorMessage =
                    'فشل التحقق من صحة بيانات الدفع. يرجى المحاولة مرة أخرى';
              } else if (dioError.response?.statusCode == 400) {
                errorMessage =
                    'بيانات الدفع غير صحيحة. يرجى التحقق من المعلومات والمحاولة مرة أخرى';
              }
              break;
            default:
              errorMessage = 'حدث خطأ غير متوقع. يرجى المحاولة مرة أخرى';
          }
        }

        Get.snackbar(
          'فشل الدفع',
          errorMessage,
          backgroundColor: AppColors.primaryDark,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
          margin: const EdgeInsets.all(10),
          borderRadius: 8,
          icon: const Icon(Icons.error_outline, color: Colors.white),
        );
        return false;
      }

      print('Payment result was neither success nor failure');
      return false;
    } catch (e) {
      print('ERROR in PaymentService.processPayment: $e');
      print('Stack trace: ${StackTrace.current}');

      Get.snackbar(
        'خطأ',
        'حدث خطأ غير متوقع: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return false;
    }
  }

  String _generateTransactionId() {
    final now = DateTime.now();
    final random = now.millisecondsSinceEpoch % 10000;
    return 'TRX-${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-$random';
  }
}
