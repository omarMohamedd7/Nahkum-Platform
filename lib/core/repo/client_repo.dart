import 'package:get/get.dart';
import 'package:nahkum/core/data/data_service.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/utils/injector.dart';
import '../models/message_model.dart';
import 'dart:io';
import 'package:dio/dio.dart' as dio;

class ClientRepo extends GetxService {
  final DataService _dataService = injector();

  Future<DataState<dynamic>> getCaseRequests() async {
    try {
      print('ClientRepo: Calling getCaseRequests API...');
      final response = await _dataService.getData(
        endPoint: '/client/case-requests',
        fromJson: (json) => json,
      );

      print(
          'ClientRepo: getCaseRequests raw response type: ${response.runtimeType}');
      if (response is DataSuccess) {
        print(
            'ClientRepo: getCaseRequests response data type: ${response.data.runtimeType}');

        // Ensure we have a valid response
        if (response.data == null) {
          print('ClientRepo: getCaseRequests response data is null');
          return DataFailed(
            dio.Response(
              data: 'No data received from server',
              statusCode: 500,
              requestOptions: dio.RequestOptions(path: '/client/case-requests'),
            ),
          );
        }

        // If the response is a map with a data field, extract it
        if (response.data is Map && response.data['data'] != null) {
          print('ClientRepo: getCaseRequests found data field in response');
          return DataSuccess(response.data['data']);
        }

        // Otherwise return the raw response
        return response;
      } else {
        print('ClientRepo: getCaseRequests failed: ${response.runtimeType}');
        return response;
      }
    } catch (e) {
      print('ClientRepo: Error in getCaseRequests: $e');
      return DataFailed(
        dio.Response(
          data: 'Error fetching case requests: $e',
          statusCode: 500,
          requestOptions: dio.RequestOptions(path: '/client/case-requests'),
        ),
      );
    }
  }

  Future<DataState<dynamic>> getPublishedCases() async {
    try {
      print('ClientRepo: Calling getPublishedCases API...');
      final response = await _dataService.getData(
        endPoint: '/client/published-cases',
        fromJson: (json) => json,
      );

      print(
          'ClientRepo: getPublishedCases raw response type: ${response.runtimeType}');
      if (response is DataSuccess) {
        print(
            'ClientRepo: getPublishedCases response data type: ${response.data.runtimeType}');

        // Log the raw response for debugging
        print('ClientRepo: getPublishedCases RAW RESPONSE: ${response.data}');

        // Ensure we have a valid response
        if (response.data == null) {
          print('ClientRepo: getPublishedCases response data is null');
          return DataFailed(
            dio.Response(
              data: 'No data received from server',
              statusCode: 500,
              requestOptions:
                  dio.RequestOptions(path: '/client/published-cases'),
            ),
          );
        }

        // Return the raw response directly without any processing
        return response;
      } else {
        print('ClientRepo: getPublishedCases failed: ${response.runtimeType}');
        return response;
      }
    } catch (e) {
      print('ClientRepo: Error in getPublishedCases: $e');
      return DataFailed(
        dio.Response(
          data: 'Error fetching published cases: $e',
          statusCode: 500,
          requestOptions: dio.RequestOptions(path: '/client/published-cases'),
        ),
      );
    }
  }

  Future<DataState<dynamic>> getCaseOffers() async {
    try {
      print('ClientRepo: Calling getCaseOffers API...');
      final response = await _dataService.getData(
        endPoint: '/client/case-offers',
        fromJson: (json) => json,
      );

      print(
          'ClientRepo: getCaseOffers raw response type: ${response.runtimeType}');
      if (response is DataSuccess) {
        print(
            'ClientRepo: getCaseOffers response data type: ${response.data.runtimeType}');

        // Ensure we have a valid response
        if (response.data == null) {
          print('ClientRepo: getCaseOffers response data is null');
          return DataFailed(
            dio.Response(
              data: 'No data received from server',
              statusCode: 500,
              requestOptions: dio.RequestOptions(path: '/client/case-offers'),
            ),
          );
        }

        // If the response is a map with a data field, extract it
        if (response.data is Map && response.data['data'] != null) {
          print('ClientRepo: getCaseOffers found data field in response');
          return DataSuccess(response.data['data']);
        }

        // Otherwise return the raw response
        return response;
      } else {
        print('ClientRepo: getCaseOffers failed: ${response.runtimeType}');
        return response;
      }
    } catch (e) {
      print('ClientRepo: Error in getCaseOffers: $e');
      return DataFailed(
        dio.Response(
          data: 'Error fetching case offers: $e',
          statusCode: 500,
          requestOptions: dio.RequestOptions(path: '/client/case-offers'),
        ),
      );
    }
  }

  Future<DataState<dynamic>> getCityLawyers() async {
    return await _dataService.getData(
      endPoint: '/client/city-lawyers',
      fromJson: (json) => json,
    );
  }

  Future<DataState<dynamic>> getAllLawyers() async {
    return await _dataService.getData(
      endPoint: '/lawyers',
      fromJson: (json) => json,
    );
  }

  Future<DataState<MessageModel>> updateProfile(
      Map<String, dynamic> profileData) async {
    return await _dataService.putData(
      endPoint: '/profilee',
      data: profileData,
      fromJson: MessageModel.fromJson,
    );
  }

  Future<DataState<dynamic>> publishCase({
    required String caseType,
    required String description,
    String? city,
  }) async {
    final Map<String, dynamic> data = {
      'case_type': caseType,
      'description': description,
    };

    if (city != null) {
      data['target_city'] = city;
    }

    return await _dataService.postData(
      endPoint: '/published-cases',
      data: data,
      fromJson: (json) => json,
    );
  }

  Future<DataState<dynamic>> createDirectCaseRequest({
    required String lawyerId,
    required String defendantName,
    required String plaintiffName,
    required String description,
    File? attachment,
  }) async {
    print(
        'ClientRepo: Creating direct case request with lawyer_id: "$lawyerId"');

    final Map<String, dynamic> data = {
      'lawyer_id': lawyerId,
      'defendant_name': defendantName,
      'plaintiff_name': plaintiffName,
      'description': description,
    };

    print('ClientRepo: Request data: $data');

    try {
      if (attachment != null) {
        return await _dataService.uploadFilesWithData(
          endPoint: '/case-requests',
          data: data,
          files: [attachment],
          fileField: 'attachment',
          fromJson: (json) => json,
        );
      } else {
        return await _dataService.postData(
          endPoint: '/case-requests',
          data: data,
          fromJson: (json) => json,
        );
      }
    } catch (e) {
      // Check if the error is about duplicate request
      final errorMessage = e.toString().toLowerCase();
      if (errorMessage.contains('already sent a request') ||
          errorMessage.contains('لايمكن ارسال اكثر من طلب')) {
        return DataFailed(
          dio.Response(
            data: 'لقد أرسلت بالفعل طلبًا إلى هذا المحامي',
            statusCode: 400,
            requestOptions: dio.RequestOptions(path: '/case-requests'),
          ),
        );
      }
      // Re-throw other errors
      rethrow;
    }
  }

  Future<DataState<MessageModel>> closePublishedCase(String caseId) async {
    return await _dataService.postData(
      endPoint: '/published-cases/$caseId/close',
      data: {},
      fromJson: MessageModel.fromJson,
    );
  }

  Future<DataState<dynamic>> acceptCaseOffer(String offerId) async {
    return await _dataService.postData(
      endPoint: '/case-offers/$offerId/action',
      data: {'action': 'accept'},
      fromJson: (json) => json,
    );
  }

  Future<DataState<dynamic>> rejectCaseOffer(String offerId) async {
    return await _dataService.postData(
      endPoint: '/case-offers/$offerId/action',
      data: {'action': 'reject'},
      fromJson: (json) => json,
    );
  }

  // For creating consultation requests using /consultations/request endpoint
  Future<DataState<dynamic>> requestConsultation(
      Map<String, dynamic> consultationData) async {
    print('ClientRepo.requestConsultation called with data:');
    print(consultationData);

    try {
      // Ensure lawyer_id is properly formatted
      if (consultationData.containsKey('lawyer_id')) {
        var lawyerId = consultationData['lawyer_id'];
        print('Original lawyer_id: $lawyerId (type: ${lawyerId.runtimeType})');

        // If it's a string that can be parsed as an integer, convert it
        if (lawyerId is String && int.tryParse(lawyerId) != null) {
          consultationData['lawyer_id'] = int.parse(lawyerId);
          print('Converted lawyer_id to int: ${consultationData['lawyer_id']}');
        }
      }

      final response = await _dataService.postData(
        endPoint: '/consultations/request',
        data: consultationData,
        fromJson: (json) => json,
      );

      print('requestConsultation response type: ${response.runtimeType}');
      if (response is DataSuccess) {
        print('requestConsultation successful: ${response.data}');
      } else if (response is DataFailed) {
        print('requestConsultation failed: ${response.error}');
        if (response.error is dio.DioException) {
          final dioError = response.error as dio.DioException;
          print('DioError type: ${dioError.type}');
          print('DioError message: ${dioError.message}');
          print('DioError response: ${dioError.response?.data}');
        }
      }

      return response;
    } catch (e) {
      print('ERROR in ClientRepo.requestConsultation: $e');
      print('Stack trace: ${StackTrace.current}');
      return DataFailed(
        dio.Response(
          data: 'Error creating consultation request: $e',
          statusCode: 500,
          requestOptions: dio.RequestOptions(path: '/consultations/request'),
        ),
      );
    }
  }

  // For general payments using /payments endpoint
  // Required parameters: consultation_request_id, payment_method, transaction_id
  Future<DataState<dynamic>> createPayment(
      Map<String, dynamic> paymentData) async {
    print('ClientRepo.createPayment called with data:');
    print(paymentData);

    try {
      final response = await _dataService.postData(
        endPoint: '/payments',
        data: paymentData,
        fromJson: (json) => json,
      );

      print('createPayment response type: ${response.runtimeType}');
      if (response is DataSuccess) {
        print('createPayment successful: ${response.data}');
      } else if (response is DataFailed) {
        print('createPayment failed: ${response.error}');
        if (response.error is dio.DioException) {
          final dioError = response.error as dio.DioException;
          print('DioError type: ${dioError.type}');
          print('DioError message: ${dioError.message}');
          print('DioError response: ${dioError.response?.data}');
        }
      }

      return response;
    } catch (e) {
      print('ERROR in ClientRepo.createPayment: $e');
      print('Stack trace: ${StackTrace.current}');
      return DataFailed(
        dio.Response(
          data: 'Error processing payment: $e',
          statusCode: 500,
          requestOptions: dio.RequestOptions(path: '/payments'),
        ),
      );
    }
  }

  Future<DataState<dynamic>> getActiveCases() async {
    try {
      print('ClientRepo: Calling getActiveCases API...');
      final response = await _dataService.getData(
        endPoint: '/client/cases?status=active',
        fromJson: (json) => json,
      );

      print(
          'ClientRepo: getActiveCases raw response type: ${response.runtimeType}');
      if (response is DataSuccess) {
        print(
            'ClientRepo: getActiveCases response data type: ${response.data.runtimeType}');

        // Ensure we have a valid response
        if (response.data == null) {
          print('ClientRepo: getActiveCases response data is null');
          return DataFailed(
            dio.Response(
              data: 'No data received from server',
              statusCode: 500,
              requestOptions: dio.RequestOptions(path: '/client/cases'),
            ),
          );
        }

        // If the response is a map with a data field, extract it
        if (response.data is Map && response.data['data'] != null) {
          print('ClientRepo: getActiveCases found data field in response');
          return DataSuccess(response.data['data']);
        }

        // Otherwise return the raw response
        return response;
      } else {
        print('ClientRepo: getActiveCases failed: ${response.runtimeType}');
        return response;
      }
    } catch (e) {
      print('ClientRepo: Error in getActiveCases: $e');
      return DataFailed(
        dio.Response(
          data: 'Error fetching active cases: $e',
          statusCode: 500,
          requestOptions: dio.RequestOptions(path: '/client/cases'),
        ),
      );
    }
  }

  Future<DataState<dynamic>> getClosedCases() async {
    try {
      print('ClientRepo: Calling getClosedCases API...');
      final response = await _dataService.getData(
        endPoint: '/client/cases?status=closed',
        fromJson: (json) => json,
      );

      print(
          'ClientRepo: getClosedCases raw response type: ${response.runtimeType}');
      if (response is DataSuccess) {
        print(
            'ClientRepo: getClosedCases response data type: ${response.data.runtimeType}');

        // Ensure we have a valid response
        if (response.data == null) {
          print('ClientRepo: getClosedCases response data is null');
          return DataFailed(
            dio.Response(
              data: 'No data received from server',
              statusCode: 500,
              requestOptions: dio.RequestOptions(path: '/client/cases'),
            ),
          );
        }

        // If the response is a map with a data field, extract it
        if (response.data is Map && response.data['data'] != null) {
          print('ClientRepo: getClosedCases found data field in response');
          return DataSuccess(response.data['data']);
        }

        // Otherwise return the raw response
        return response;
      } else {
        print('ClientRepo: getClosedCases failed: ${response.runtimeType}');
        return response;
      }
    } catch (e) {
      print('ClientRepo: Error in getClosedCases: $e');
      return DataFailed(
        dio.Response(
          data: 'Error fetching closed cases: $e',
          statusCode: 500,
          requestOptions: dio.RequestOptions(path: '/client/cases'),
        ),
      );
    }
  }

  Future<DataState<MessageModel>> updateProfileImage(File imageFile) async {
    try {
      return await _dataService.uploadFilesWithData(
        endPoint: '/profile/image',
        data: {},
        files: [imageFile],
        fileField: 'image',
        fromJson: MessageModel.fromJson,
      );
    } catch (e) {
      print('ClientRepo: Error updating profile image: $e');
      return DataFailed(
        dio.Response(
          data: 'Error updating profile image: $e',
          statusCode: 500,
          requestOptions: dio.RequestOptions(path: '/profile/image'),
        ),
      );
    }
  }

  Future<DataState<MessageModel>> processConsultationPayment(
      Map<String, dynamic> paymentData) async {
    try {
      return await _dataService.postData(
        endPoint: '/payments/consultation',
        data: paymentData,
        fromJson: MessageModel.fromJson,
      );
    } catch (e) {
      print('ClientRepo: Error processing payment: $e');
      return DataFailed(
        dio.Response(
          data: 'Error processing payment: $e',
          statusCode: 500,
          requestOptions: dio.RequestOptions(path: '/payments/consultation'),
        ),
      );
    }
  }
}
