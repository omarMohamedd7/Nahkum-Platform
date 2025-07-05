import 'package:nahkum/features/lawer/data/models/published_case_client_model.dart';

class CaseModel {
  final int caseId;
  final String caseNumber;
  final String caseType;
  final String description;
  final String status;
  final String? clientName;
  final PublishedCaseClientModel? client;

  CaseModel({
    required this.caseId,
    required this.caseNumber,
    required this.caseType,
    required this.description,
    required this.status,
    required this.client,
    required this.clientName,
  });

  factory CaseModel.fromJson(Map<String, dynamic> json) {
    return CaseModel(
      caseId: json['case_id'],
      caseNumber: json['case_number'],
      caseType: json['case_type'],
      description: json['description'],
      status: json['status'],
      clientName: json['client_name'],
      client: json['client'] == null
          ? null
          : PublishedCaseClientModel.fromJson(json['client']),
    );
  }
}
