import 'package:nahkum/features/lawer/data/models/case_model.dart';
import 'package:nahkum/features/lawer/data/models/published_case_client_model.dart';

class PublishedCaseModel {
  final int publishedCaseId;
  final String status;
  final bool hasOffered;
  final String targetCity;
  final String targetSpecialization;
  final DateTime? createdAt;
  final CaseModel caseDetails;
  final PublishedCaseClientModel client;

  PublishedCaseModel({
    required this.publishedCaseId,
    required this.status,
    required this.targetCity,
    required this.targetSpecialization,
    this.createdAt,
    required this.caseDetails,
    required this.client,
    required this.hasOffered,
  });

  factory PublishedCaseModel.fromJson(Map<String, dynamic> json) {
    return PublishedCaseModel(
      publishedCaseId: json['published_case_id'],
      status: json['status'],
      targetCity: json['target_city'],
      hasOffered: json['has_offered'].toString() == '1',
      targetSpecialization: json['target_specialization'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      caseDetails: CaseModel.fromJson(json['case']),
      client: PublishedCaseClientModel.fromJson(json['client']),
    );
  }
}
