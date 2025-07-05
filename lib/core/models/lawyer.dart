class Lawyer {
  final String id;
  final String name;
  final String location;
  final String description;
  final double consultationFee;
  final String imageUrl;
  final String specialization;

  const Lawyer({
    required this.id,
    required this.name,
    required this.location,
    required this.description,
    required this.consultationFee,
    required this.imageUrl,
    required this.specialization,
  });

  // Helper method to get ID as integer
  int getIdAsInt() {
    try {
      if (id.isEmpty) return 0;
      final parsedId = int.tryParse(id);
      return parsedId ?? 0;
    } catch (e) {
      print('Lawyer: Error parsing ID to int: $e');
      return 0;
    }
  }

  // Check if this lawyer has a valid ID
  bool hasValidId() {
    return id.isNotEmpty && id != '0' && id != 'null';
  }

  @override
  String toString() {
    return 'Lawyer(id: $id, name: $name, location: $location, specialization: $specialization)';
  }
}
