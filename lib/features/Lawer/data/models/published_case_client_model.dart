class PublishedCaseClientModel {
  final int clientId;
  final String name;
  final String city;
  final String? image;
  final String? phone;

  PublishedCaseClientModel({
    required this.clientId,
    required this.name,
    required this.city,
    required this.image,
    required this.phone,
  });

  factory PublishedCaseClientModel.fromJson(Map<String, dynamic> json) {
    return PublishedCaseClientModel(
      clientId: json['client_id'] ?? json['id'],
      name: json['name'] ?? '',
      city: json['city'] ?? '',
      image: json['image'] ?? '',
      phone: json['phone'] ?? json['phone_number'] ?? '',
    );
  }
}
