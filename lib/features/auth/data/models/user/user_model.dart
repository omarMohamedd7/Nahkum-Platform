class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? profileImageUrl;
  final String? profileImageFullUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ProfileInfo profileInfo;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.profileImageUrl,
    this.profileImageFullUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.profileInfo,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      profileImageUrl: json['profile_image_url'],
      profileImageFullUrl: json['profile_image_full_url'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      profileInfo: ProfileInfo.fromJson(json['profile_info']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'profile_image_url': profileImageUrl,
      'profile_image_full_url': profileImageFullUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'profile_info': profileInfo.toJson(),
    };
  }
}

class ProfileInfo {
  final int lawyerId;
  final String? phone;
  final String specialization;
  final String city;
  final String consultFee;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProfileInfo({
    required this.lawyerId,
    this.phone,
    required this.specialization,
    required this.city,
    required this.consultFee,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProfileInfo.fromJson(Map<String, dynamic> json) {
    return ProfileInfo(
      lawyerId: json['id'] ??
          json['client_id'] ??
          json['judge_id'] ??
          json['lawyer_id'],
      phone: json['phone'],
      specialization: json['specialization'] ?? '',
      city: json['city'] ?? '',
      consultFee: json['consult_fee'] ?? '',
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at']),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'lawyer_id': lawyerId,
      'phone': phone,
      'specialization': specialization,
      'city': city,
      'consult_fee': consultFee,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
