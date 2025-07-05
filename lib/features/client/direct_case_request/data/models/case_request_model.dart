import 'dart:io';

class CaseRequestModel {
  final String? id;
  final String? caseType;
  final String plaintiffName;
  final String defendantName;
  final String caseNumber;
  final String caseDescription;
  final List<File>? attachment;
  final DateTime? createdAt;

  CaseRequestModel({
    this.id,
    this.caseType,
    required this.plaintiffName,
    required this.defendantName,
    required this.caseNumber,
    required this.caseDescription,
    required this.attachment,
    this.createdAt,
  });

  CaseRequestModel copyWith({
    String? id,
    String? caseType,
    String? plaintiffName,
    String? defendantName,
    String? caseNumber,
    String? caseDescription,
    List<File>? files,
    DateTime? createdAt,
  }) {
    return CaseRequestModel(
      id: id ?? this.id,
      caseType: caseType ?? this.caseType,
      plaintiffName: plaintiffName ?? this.plaintiffName,
      defendantName: defendantName ?? this.defendantName,
      caseNumber: caseNumber ?? this.caseNumber,
      caseDescription: caseDescription ?? this.caseDescription,
      attachment: files ?? attachment,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caseType': caseType,
      'plaintiffName': plaintiffName,
      'defendantName': defendantName,
      'caseNumber': caseNumber,
      'caseDescription': caseDescription,
      'filesCount': attachment?.length ?? 0,
      'createdAt': createdAt?.toIso8601String(),
    };
  }
}
