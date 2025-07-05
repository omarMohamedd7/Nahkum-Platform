import 'dart:io';
import 'package:dio/dio.dart';
import 'package:nahkum/core/data/data_service.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/models/message_model.dart';
import 'package:nahkum/core/utils/injector.dart';
import 'package:nahkum/features/auth/data/models/auth_response_model.dart';

class AuthRepo {
  final DataService _dataService = injector();

  Future<DataState<AuthResponseModel>> login({
    required String email,
    required String password,
    String? fcmToken,
  }) async {
    return await _dataService.postData(
      endPoint: '/login',
      data: {
        'email': email,
        'password': password,
        if (fcmToken != null) 'fcm_token': fcmToken,
      },
      fromJson: AuthResponseModel.fromJson,
    );
  }

  Future<DataState<AuthResponseModel>> loginWithGoogle({
    required String email,
    required String name,
    String? fcmToken,
  }) async {
    return await _dataService.postData(
      endPoint: '/google-login',
      data: {
        'email': email,
        'name': name,
        if (fcmToken != null) 'fcm_token': fcmToken,
      },
      fromJson: AuthResponseModel.fromJson,
    );
  }

  Future<DataState<MessageModel>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String city,
    required String? specialization,
    required String? consultFee,
    required String role,
    String? profileImagePath,
    String? fcmToken,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'email': email,
      'password': password,
      'phone_number': phone,
      'city': city,
      if (specialization != null) 'specialization': specialization,
      if (consultFee != null) 'consult_fee': consultFee,
      'role': role,
      if (fcmToken != null) 'fcm_token': fcmToken,
      if (profileImagePath != null && profileImagePath.isNotEmpty)
        'profile_image_url': await MultipartFile.fromFile(profileImagePath),
    });

    return await _dataService.postData(
      endPoint: '/register',
      data: formData,
      fromJson: MessageModel.fromJson,
    );
  }

  Future<DataState<MessageModel>> requestPasswordReset({
    required String email,
  }) async {
    return await _dataService.postData(
      endPoint: '/reset-password',
      data: {'email': email},
      fromJson: MessageModel.fromJson,
    );
  }

  Future<DataState<AuthResponseModel>> verifyOtp({
    required String email,
    required String code,
    String? fcmToken,
  }) async {
    try {
      return await _dataService.postData(
        endPoint: '/login/verify-otp',
        data: {
          'email': email,
          'otp': code,
          if (fcmToken != null) 'fcm_token': fcmToken,
        },
        fromJson: AuthResponseModel.fromJson,
      );
    } catch (e) {
      // Handle any unexpected errors
      return DataFailed(
        Response(
          data:
              'فشل الاتصال بالخادم. يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى.',
          statusCode: HttpStatus.serviceUnavailable,
          requestOptions: RequestOptions(),
        ),
      );
    }
  }

  Future<DataState<MessageModel>> verifyResetOtp({
    required String email,
    required String code,
  }) async {
    return await _dataService.postData(
      endPoint: '/reset-password/verify-otp',
      data: {'email': email, 'otp': code},
      fromJson: MessageModel.fromJson,
    );
  }

  Future<DataState<MessageModel>> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    return await _dataService.postData(
      endPoint: '/reset-password',
      data: {'email': email, 'password': newPassword},
      fromJson: MessageModel.fromJson,
    );
  }

  Future<DataState<MessageModel>> sendOtpToEmail({
    required String email,
  }) async {
    return await _dataService.postData(
      endPoint: '/resend-otp',
      data: {'email': email, 'purpose': 'authentication'},
      fromJson: MessageModel.fromJson,
    );
  }
}
