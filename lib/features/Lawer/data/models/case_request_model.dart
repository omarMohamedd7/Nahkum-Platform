import 'package:nahkum/features/lawer/data/models/case_status_enum.dart';
import 'package:nahkum/features/lawer/data/models/case_model.dart';
import 'package:nahkum/features/lawer/data/models/published_case_client_model.dart';

class CaseRequestModel {
  final int requestId;
  final CaseStatus status;
  final DateTime? createdAt;
  final CaseModel caseDetails;
  final PublishedCaseClientModel? client;

  CaseRequestModel({
    required this.requestId,
    required this.status,
    this.createdAt,
    required this.caseDetails,
    required this.client,
  });

  factory CaseRequestModel.fromJson(Map<String, dynamic> json) {
    return CaseRequestModel(
      requestId: json['request_id'],
      status: CaseStatus.parseCaseStatus(json['status'].toString()),
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      caseDetails: CaseModel.fromJson(json['case']),
      client: PublishedCaseClientModel.fromJson(json['client']),
    );
  }
  String? getFormattedDate() {
    try {
      final DateTime dateTime = createdAt!;
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return createdAt?.toIso8601String();
    }
  }
}
