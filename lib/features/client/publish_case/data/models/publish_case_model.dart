class PublishCaseModel {
  final String? id;
  final String? caseType;
  final String description;
  final String status;
  final String? targetCity;

  PublishCaseModel({
    this.id,
    this.caseType,
    required this.description,
    DateTime? createdAt,
    this.status = 'pending',
    this.targetCity,
  });

  PublishCaseModel copyWith({
    String? id,
    String? caseType,
    String? description,
    String? status,
    String? targetCity,
  }) {
    return PublishCaseModel(
      id: id ?? this.id,
      caseType: caseType ?? this.caseType,
      description: description ?? this.description,
      status: status ?? this.status,
      targetCity: targetCity ?? this.targetCity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'caseType': caseType,
      'description': description,
      'status': status,
      'targetCity': targetCity,
    };
  }

  factory PublishCaseModel.fromJson(Map<String, dynamic> json) {
    return PublishCaseModel(
      id: json['id'],
      caseType: json['caseType'],
      description: json['description'],
      status: json['status'],
      targetCity: json['targetCity'],
    );
  }
}
