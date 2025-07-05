class CasePreview {
  final String id;
  final String caseType;
  final String description;
  final String requestStatus;
  final String Status;
  final String? lawyerName;
  final String? lawyerId;
  final String? userId;

  CasePreview({
    required this.id,
    required this.caseType,
    required this.description,
    required this.requestStatus,
    required this.Status,
    this.lawyerName,
    this.lawyerId,
    this.userId,
  });

  factory CasePreview.fromJson(Map<String, dynamic> json) {
    final caseData = json['case'] ?? {};
    final lawyerData = json['lawyer'] ?? {};
    print(lawyerData.toString() + "dwqko dkasdko sdkoaskd");
    return CasePreview(
      id: json['case_id'] ?? 'غير محدد',
      caseType: caseData['case_type'] ?? 'غير محدد',
      description: caseData['description'] ?? '',
      requestStatus: json['status'] ?? 'غير معروف',
      Status: json['status'] ?? 'غير معروف',
      lawyerName: lawyerData['name'],
      lawyerId:
          lawyerData['id'] ?? lawyerData['lawyer_id'] ?? lawyerData['lawyerId'],
      userId: lawyerData['user_id'].toString(),
    );
  }
}
