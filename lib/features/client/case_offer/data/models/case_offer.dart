class CaseOffer {
  final String id;
  final String caseNumber;
  final String caseType;
  final String lawyerId;
  final String lawyerName;
  final String description;
  final double price;
  final String status;
  final DateTime createdAt;

  CaseOffer({
    required this.id,
    required this.caseNumber,
    required this.caseType,
    required this.lawyerId,
    required this.lawyerName,
    required this.description,
    required this.price,
    required this.status,
    required this.createdAt,
  });

  factory CaseOffer.fromJson(Map<String, dynamic> json) {
    return CaseOffer(
      id: json['id']?.toString() ?? '',
      caseNumber: json['case_number']?.toString() ?? '',
      caseType: json['case_type']?.toString() ?? '',
      lawyerId: json['lawyer_id']?.toString() ?? '',
      lawyerName: json['lawyer_name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] != null) ? (json['price'] as num).toDouble() : 0.0,
      status: json['status']?.toString() ?? 'pending',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'].toString())
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'case_number': caseNumber,
      'case_type': caseType,
      'lawyer_id': lawyerId,
      'lawyer_name': lawyerName,
      'description': description,
      'price': price,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
