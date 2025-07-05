import 'dart:convert';
import 'package:dio/dio.dart';

class PaypalService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://api-m.sandbox.paypal.com'));

  final String clientId = 'AUF2cMuydRvmCt5DX9T090H9rLTQLvJsC6nVt_Vrkl1n5O0q2maAcMuKPIpiR8935UB4bLQleIlkx_uK';
  final String secret = 'ECWSoG2zxoIoFqlIbSYp9pEhqqOLHUvwu1Nj4jXAPdlUjmS37VYibOhvyjJ0y8ddbneIZyDVgVRRd7oH';

  Future<bool> processDirectPayment({required double amount}) async {
    try {
      // 1. الحصول على التوكن
      final tokenResponse = await _dio.post(
        '/v1/oauth2/token',
        data: {'grant_type': 'client_credentials'},
        options: Options(
          headers: {
            'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$secret'))}',
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        ),
      );

      final accessToken = tokenResponse.data['access_token'];

      // 2. إنشاء الطلب
      final orderResponse = await _dio.post(
        '/v2/checkout/orders',
        data: {
          "intent": "CAPTURE",
          "purchase_units": [
            {
              "amount": {
                "currency_code": "USD",
                "value": amount.toStringAsFixed(2),
              },
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

      final orderId = orderResponse.data['id'];

      // 3. تنفيذ الدفع مباشرة بدون approval link
      final captureResponse = await _dio.post(
        '/v2/checkout/orders/$orderId/capture',
        options: Options(
          headers: {
            'Authorization': 'Bearer $accessToken',
            'Content-Type': 'application/json',
          },
        ),
      );

      // 4. التأكد من نجاح العملية
      if (captureResponse.statusCode == 201 || captureResponse.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
