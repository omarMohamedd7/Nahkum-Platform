class CaseOffer {
  final String id;
  final String caseType;
  final String lawyerId;
  final String lawyerName;
  final String message;
  final String expectedPrice;
  final String status;
  final DateTime createdAt;
  final String? lawyerSpecialization;
  final String? publishedCaseId;

  CaseOffer({
    required this.id,
    required this.caseType,
    required this.lawyerId,
    required this.lawyerName,
    required this.message,
    required this.expectedPrice,
    required this.status,
    required this.createdAt,
    this.lawyerSpecialization,
    this.publishedCaseId,
  });

  factory CaseOffer.fromJson(Map<String, dynamic> json) {
    // Extract nested objects
    final lawyerData = json['lawyer'] as Map<String, dynamic>? ?? {};
    final publishedCaseData =
        json['published_case'] as Map<String, dynamic>? ?? {};
    final caseData = publishedCaseData['case'] as Map<String, dynamic>? ?? {};

    return CaseOffer(
      id: json['offer_id']?.toString() ?? '',
      caseType: caseData['case_type']?.toString() ?? 'غير محدد',
      lawyerId: lawyerData['lawyer_id']?.toString() ?? '',
      lawyerName: lawyerData['name']?.toString() ?? 'غير محدد',
      message: json['message']?.toString() ?? '',
      expectedPrice: json['expected_price']?.toString() ?? '0',
      status: json['status']?.toString() ?? 'Pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
      lawyerSpecialization: lawyerData['specialization']?.toString(),
      publishedCaseId: publishedCaseData['published_case_id']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'offer_id': id,
      'case_type': caseType,
      'lawyer_id': lawyerId,
      'name': lawyerName,
      'message': message,
      'expected_price': expectedPrice,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'specialization': lawyerSpecialization,
      'published_case_id': publishedCaseId,
    };
  }

  // Helper method to translate status to Arabic
  String getArabicStatus() {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'قيد الانتظار';
      case 'approved':
        return 'تمت الموافقة';
      case 'rejected':
        return 'مرفوض';
      default:
        return status;
    }
  }
}
