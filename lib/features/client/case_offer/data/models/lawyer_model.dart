class LawyerModel {
  final String id;
  final String name;
  final String city;
  final String description;
  final double price;
  final String imageUrl;
  final String specialization;

  const LawyerModel({
    required this.id,
    required this.name,
    required this.city,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.specialization,
  });

  LawyerModel copyWith({
    String? id,
    String? name,
    String? location,
    String? description,
    double? price,
    String? imageUrl,
    String? specialization,
  }) {
    return LawyerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      city: location ?? city,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      specialization: specialization ?? this.specialization,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': city,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'specialization': specialization,
    };
  }

  factory LawyerModel.fromJson(Map<String, dynamic> json) {
    return LawyerModel(
      id: json['id'],
      name: json['name'],
      city: json['location'],
      description: json['description'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      specialization: json['specialization'],
    );
  }
}
