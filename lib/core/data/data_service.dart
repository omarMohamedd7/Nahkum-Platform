import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:nahkum/core/data/data_consts.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/routes/app_routes.dart';
import 'package:nahkum/core/utils/cache_helper.dart';
import 'package:get_storage/get_storage.dart';

class DataService {
  final Dio _dio;

  DataService(this._dio);

  Options options() {
    final token = GetStorage().read(CacheHelper.token);
    return Options(
      headers: {
        if (token != null) 'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );
  }

  Future<DataState<T>> getData<T>({
    required String endPoint,
    Map<String, dynamic>? queryParameters,
    required Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.get(
        DataConsts.apiBaseURL + endPoint,
        options: options(),
        queryParameters: queryParameters,
      );
      return handleDataState(response: response, fromJson: fromJson);
    } on DioException catch (error) {
      return handleDataState(response: error.response, fromJson: fromJson);
    }
  }

  Future<DataState<T>> postData<T>({
    dynamic data,
    String? baseUrl,
    required String endPoint,
    required Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.post(
        (baseUrl ?? DataConsts.apiBaseURL) + endPoint,
        options: options(),
        data: data,
      );
      return handleDataState(response: response, fromJson: fromJson);
    } on DioException catch (error) {
      return handleDataState(response: error.response, fromJson: fromJson);
    }
  }

  Future<DataState<T>> putData<T>({
    dynamic data,
    required String endPoint,
    required Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.put(
        DataConsts.apiBaseURL + endPoint,
        options: options(),
        data: data,
      );
      return handleDataState(response: response, fromJson: fromJson);
    } on DioException catch (error) {
      return handleDataState(response: error.response, fromJson: fromJson);
    }
  }

  Future<DataState<T>> deleteData<T>({
    required String endPoint,
    required Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await _dio.delete(
        DataConsts.apiBaseURL + endPoint,
        options: options(),
      );
      return handleDataState(response: response, fromJson: fromJson);
    } on DioException catch (error) {
      return handleDataState(response: error.response, fromJson: fromJson);
    }
  }

  Future<DataState<T>> uploadFilesWithData<T>({
    required String endPoint,
    required Map<String, dynamic> data,
    required List<File> files,
    required String fileField,
    required Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final formData = FormData.fromMap(data);

      for (int i = 0; i < files.length; i++) {
        final file = files[i];
        final fileName = file.path.split('/').last;
        formData.files.add(
          MapEntry(
            files.length > 1 ? '$fileField[$i]' : fileField,
            await MultipartFile.fromFile(
              file.path,
              filename: fileName,
            ),
          ),
        );
      }

      final response = await _dio.post(
        DataConsts.apiBaseURL + endPoint,
        options: options(),
        data: formData,
      );

      return handleDataState(response: response, fromJson: fromJson);
    } on DioException catch (error) {
      return handleDataState(response: error.response, fromJson: fromJson);
    }
  }

  Future<DataState<T>> handleDataState<T>({
    required Response? response,
    required Function(Map<String, dynamic>) fromJson,
  }) async {
    if (response != null) {
      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.created) {
        // Print response data for debugging
        print(
            'DataService: Raw response data type: ${response.data.runtimeType}');
        print('DataService: Raw response data: ${response.data}');

        try {
          if (response.data is Map<String, dynamic>) {
            // If it's already a Map<String, dynamic>, use it directly
            final object = fromJson(response.data);
            return DataSuccess(object as T);
          } else if (response.data is String) {
            // If it's a string, try to decode it as JSON
            final decoded = jsonDecode(response.data);
            if (decoded is Map<String, dynamic>) {
              final object = fromJson(decoded);
              return DataSuccess(object as T);
            } else {
              // If it's not a Map<String, dynamic>, return the raw decoded data
              return DataSuccess(decoded as T);
            }
          } else {
            // For other types (like List or non-string/non-map), return as is
            return DataSuccess(response.data as T);
          }
        } catch (e) {
          print('DataService: Error processing response: $e');
          return DataFailed(
            Response(
              data: 'Error processing response: $e',
              statusCode: HttpStatus.internalServerError,
              requestOptions: response.requestOptions,
            ),
          );
        }
      } else if (response.statusCode == HttpStatus.unauthorized) {
        if (response.requestOptions.path.contains('verify-otp')) {
          return DataFailed(
            Response(
              data: response.data['error'] ??
                  response.data['message'] ??
                  'رمز التحقق غير صحيح',
              statusCode: response.statusCode,
              requestOptions: response.requestOptions,
            ),
          );
        } else if (response.requestOptions.path.contains('login') ||
            response.requestOptions.path.contains('google-login')) {
          // For login failures, return error without redirecting
          return DataFailed(
            Response(
              data: response.data['error'] ??
                  response.data['message'] ??
                  'بيانات الاعتماد غير صالحة، يرجى التحقق من البريد الإلكتروني وكلمة المرور',
              statusCode: response.statusCode,
              requestOptions: response.requestOptions,
            ),
          );
        } else {
          CacheHelper.logout();
          Get.offAllNamed(Routes.SPLASH);
        }
      } else if (response.statusCode == HttpStatus.badRequest) {
        if (response.data is Map &&
            response.data['message'] != null &&
            response.data['message']
                .toString()
                .toLowerCase()
                .contains('already sent a request')) {
          return DataFailed(
            Response(
              data: 'لايمكن ارسال اكثر من طلب قضية لنفس المحامي',
              statusCode: response.statusCode,
              requestOptions: response.requestOptions,
            ),
          );
        }
      }
    }

    final errorMessage = response?.data is Map
        ? (response?.data['error'] ??
            response?.data['message'] ??
            'حدث خطأ غير متوقع')
        : 'فشل الاتصال بالخادم';

    return DataFailed(
      Response(
        data: errorMessage,
        statusCode: response?.statusCode ?? HttpStatus.serviceUnavailable,
        requestOptions: response?.requestOptions ?? RequestOptions(),
      ),
    );
  }
}
