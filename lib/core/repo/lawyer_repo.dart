import 'dart:io';

import 'package:dio/dio.dart';
import 'package:nahkum/core/data/data_service.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/models/message_model.dart';
import 'package:nahkum/core/utils/injector.dart';
import 'package:nahkum/features/lawer/data/models/availble_cases_model.dart';
import 'package:nahkum/features/lawer/data/models/case_details_model.dart';
import 'package:nahkum/features/lawer/data/models/case_requests_model.dart';
import 'package:nahkum/features/lawer/data/models/cases_model.dart';
import 'package:nahkum/features/lawer/data/models/my_cases_model.dart';

class LawyerRepo {
  final DataService _dataService = injector();

  Future<DataState<AvailbleCasesModel>> getAvailableCases() async {
    return await _dataService.getData(
      endPoint: '/lawyer/available-cases',
      fromJson: AvailbleCasesModel.fromJson,
    );
  }

  Future<DataState<MyCasesModel>> getMyCases() async {
    return await _dataService.getData(
      endPoint: '/lawyer/cases',
      fromJson: MyCasesModel.fromJson,
    );
  }

  Future<DataState<CasesModel>> getClientsCases() async {
    return await _dataService.getData(
      endPoint: '/lawyer/clients-cases',
      fromJson: CasesModel.fromJson,
    );
  }

  Future<DataState<CaseDetailsModel>> getCaseAttachments(caseId) async {
    return await _dataService.getData(
      endPoint: '/lawyer/cases/${caseId.toString()}/attachment',
      fromJson: CaseDetailsModel.fromJson,
    );
  }

  Future<DataState<CaseRequestsModel>> getClientCaseRequests() async {
    return await _dataService.getData(
      endPoint: '/lawyer/case-requests',
      fromJson: CaseRequestsModel.fromJson,
    );
  }

  Future<DataState<MessageModel>> makeOffer({
    required int caseId,
    required String expectedPrice,
    required String message,
  }) async {
    return await _dataService.postData(
      endPoint: '/published-cases/$caseId/offers',
      data: {
        'expected_price': expectedPrice,
        'message': message,
      },
      fromJson: MessageModel.fromJson,
    );
  }

  Future<DataState<MessageModel>> acceptRejectCaseRequest({
    required int requestId,
    required String action,
  }) async {
    return await _dataService.postData(
      endPoint: '/lawyer/case-requests/$requestId/action',
      data: {'action': action},
      fromJson: MessageModel.fromJson,
    );
  }

  Future<DataState<MessageModel>> updateProfile({
    required String name,
    required String email,
    required String city,
    required String specialization,
    required String consultFee,
    File? profileImage,
  }) async {
    final formData = FormData.fromMap({
      'name': name,
      'email': email,
      'city': city,
      'specialization': specialization,
      'consult_fee': consultFee,
      if (profileImage != null)
        'profile_image': await MultipartFile.fromFile(profileImage.path),
    });

    return await _dataService.putData(
      endPoint: '/lawyer/update-profile',
      data: formData,
      fromJson: MessageModel.fromJson,
    );
  }
}
