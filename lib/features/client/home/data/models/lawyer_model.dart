class Lawyer {
  final String id;
  final String name;
  final String city;
  final String description;
  final double price;
  final String imageUrl;
  final String specialization;

  const Lawyer({
    required this.id,
    required this.name,
    required this.city,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.specialization,
  });

  @override
  String toString() {
    return 'Lawyer(id: $id, name: $name, location: $city, specialization: $specialization)';
  }
}
