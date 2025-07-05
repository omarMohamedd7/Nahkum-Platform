class ClientProfileModel {
  final int clientId;
  final String phone;
  final String city;
  final String createdAt;
  final String updatedAt;

  const ClientProfileModel({
    required this.clientId,
    required this.phone,
    required this.city,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ClientProfileModel.fromJson(Map<String, dynamic> json) {
    return ClientProfileModel(
      clientId: json['client_id'] as int,
      phone: json['phone'] as String,
      city: json['city'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'client_id': clientId,
      'phone': phone,
      'city': city,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  ClientProfileModel copyWith({
    int? clientId,
    String? phone,
    String? city,
    String? createdAt,
    String? updatedAt,
  }) {
    return ClientProfileModel(
      clientId: clientId ?? this.clientId,
      phone: phone ?? this.phone,
      city: city ?? this.city,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
