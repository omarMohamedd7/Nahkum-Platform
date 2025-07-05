class LawyerProfileModel {
  final int lawyerId;
  final String phone;
  final String specialization;
  final String city;
  final String consultFee;
  final String createdAt;
  final String updatedAt;

  const LawyerProfileModel({
    required this.lawyerId,
    required this.phone,
    required this.specialization,
    required this.city,
    required this.consultFee,
    required this.createdAt,
    required this.updatedAt,
  });

  factory LawyerProfileModel.fromJson(Map<String, dynamic> json) {
    return LawyerProfileModel(
      lawyerId: json['lawyer_id'] as int,
      phone: json['phone'] as String,
      specialization: json['specialization'] as String,
      city: json['city'] as String,
      consultFee: json['consult_fee'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lawyer_id': lawyerId,
      'phone': phone,
      'specialization': specialization,
      'city': city,
      'consult_fee': consultFee,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  LawyerProfileModel copyWith({
    int? lawyerId,
    String? phone,
    String? specialization,
    String? city,
    String? consultFee,
    String? createdAt,
    String? updatedAt,
  }) {
    return LawyerProfileModel(
      lawyerId: lawyerId ?? this.lawyerId,
      phone: phone ?? this.phone,
      specialization: specialization ?? this.specialization,
      city: city ?? this.city,
      consultFee: consultFee ?? this.consultFee,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
