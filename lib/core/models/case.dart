import 'dart:core';

class Case {
  final String id;
  final String title;
  final String description;
  final String caseNumber;
  final String caseType;
  String status;
  final String? lawyerId;
  final String? lawyerUserId;
  final String? lawyerName;
  final List<String> attachments;
  final DateTime? createdAt;
  final String? requestId;

  Case({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.caseNumber,
    this.lawyerId,
    this.lawyerUserId,
    this.lawyerName,
    required this.attachments,
    required this.caseType,
    this.createdAt,
    this.requestId,
  });

  factory Case.fromJson(Map<String, dynamic> json) {
    // Check if this is a case-requests response with nested structure
    if (json.containsKey('request_id') && json.containsKey('case')) {
      // This is a case request with nested case data
      final requestId = json['request_id'].toString();
      final caseData = json['case'] as Map<String, dynamic>;
      final lawyerData = json['lawyer'] as Map<String, dynamic>?;

      // Extract attachments safely
      List<String> attachments = [];
      if (caseData['attachments'] != null && caseData['attachments'] is List) {
        attachments = List<String>.from(caseData['attachments']);
      }

      // Extract created_at date
      DateTime? createdAt;
      if (json['created_at'] != null) {
        try {
          createdAt = DateTime.parse(json['created_at'].toString());
        } catch (e) {
          print('Error parsing created_at date: $e');
        }
      }

      return Case(
        id: caseData['case_id']?.toString() ?? '',
        title: caseData['case_type'] ?? 'طلب قضية',
        description: caseData['description'] ?? '',
        status: json['status'] ?? 'بانتظار الموافقة',
        caseNumber: caseData['case_number'] ?? 'طلب جديد',
        caseType: caseData['case_type'] ?? '',
        lawyerId: lawyerData?['lawyer_id']?.toString(),
        lawyerName: lawyerData?['name']?.toString(),
        attachments: attachments,
        createdAt: createdAt,
        requestId: requestId,
      );
    }

    // Original implementation for direct case objects
    // Extract attachments safely
    List<String> attachments = [];
    if (json['attachments'] != null && json['attachments'] is List) {
      attachments = List<String>.from(json['attachments']);
    }

    // Extract ID safely
    String id = '';
    if (json['id'] != null) {
      id = json['id'].toString();
    }

    // Extract case number safely
    String caseNumber = '';
    if (json['case_number'] != null) {
      caseNumber = json['case_number'].toString();
    } else if (json['caseNumber'] != null) {
      caseNumber = json['caseNumber'].toString();
    } else if (json['clientId'] != null) {
      caseNumber = json['clientId'].toString();
    }

    // Extract case type safely - prioritize case_type field
    String caseType = '';
    if (json['case_type'] != null) {
      caseType = json['case_type'].toString();
    } else if (json['caseType'] != null) {
      caseType = json['caseType'].toString();
    } else if (json['type'] != null) {
      caseType = json['type'].toString();
    }

    // Extract description safely
    String description = '';
    if (json['description'] != null) {
      description = json['description'].toString();
    }

    // Extract lawyer information
    String? lawyerId;
    String? lawyerUserId;
    String? lawyerName;

    if (json['lawyer'] != null && json['lawyer'] is Map) {
      final lawyer = json['lawyer'] as Map<String, dynamic>;
      lawyerId =
          lawyer['lawyerId']?.toString() ?? lawyer['lawyer_id']?.toString();
      lawyerName = lawyer['name']?.toString();
      lawyerUserId = lawyer['user_id'].toString();
      print(lawyerUserId.toString() + "1 pwpwpwpwpwpwdqwdq");
    } else {
      print(lawyerUserId.toString() + "2 pwpwpwpwpwpwdqwdq");
      lawyerId = json['lawyerId']?.toString() ?? json['lawyer_id']?.toString();
    }
    print(lawyerUserId.toString() + "3 pwpwpwpwpwpwdqwdq");

    // Extract created_at date
    DateTime? createdAt;
    if (json['created_at'] != null) {
      try {
        createdAt = DateTime.parse(json['created_at'].toString());
      } catch (e) {
        print('Error parsing created_at date: $e');
      }
    }

    return Case(
      id: id,
      title: json['title'] ?? caseType ?? 'طلب قضية',
      description: description,
      status: json['status'] ?? 'بانتظار الموافقة',
      caseNumber: caseNumber.isEmpty ? 'طلب جديد' : caseNumber,
      caseType: caseType,
      lawyerId: lawyerId,
      lawyerName: lawyerName,
      attachments: attachments,
      createdAt: createdAt,
      lawyerUserId: lawyerUserId,
    );
  }

  // Helper factory method specifically for case-requests endpoint
  factory Case.fromCaseRequestJson(Map<String, dynamic> json) {
    final requestId = json['request_id'].toString();
    final caseData = json['case'] as Map<String, dynamic>;
    final lawyerData = json['lawyer'] as Map<String, dynamic>?;

    // Extract attachments safely
    List<String> attachments = [];
    if (caseData['attachments'] != null && caseData['attachments'] is List) {
      attachments = List<String>.from(caseData['attachments']);
    }

    // Extract created_at date
    DateTime? createdAt;
    if (json['created_at'] != null) {
      try {
        createdAt = DateTime.parse(json['created_at'].toString());
      } catch (e) {
        print('Error parsing created_at date: $e');
      }
    }

    return Case(
      id: caseData['case_id']?.toString() ?? '',
      title: caseData['case_type'] ?? 'طلب قضية',
      description: caseData['description'] ?? '',
      status: json['status'] ?? 'بانتظار الموافقة',
      caseNumber: caseData['case_number'] ?? 'طلب جديد',
      caseType: caseData['case_type'] ?? '',
      lawyerId: lawyerData?['lawyer_id']?.toString(),
      lawyerName: lawyerData?['name']?.toString(),
      attachments: attachments,
      createdAt: createdAt,
      requestId: requestId,
    );
  }

  // Helper method to parse a list of case requests
  static List<Case> fromCaseRequestsList(List<dynamic> jsonList) {
    return jsonList.map((json) => Case.fromCaseRequestJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'status': status,
      'caseNumber': caseNumber,
      'lawyerId': lawyerId,
      'lawyerName': lawyerName,
      'attachments': attachments,
      'createdAt': createdAt?.toIso8601String(),
      'requestId': requestId,
    };
  }
}
