class ContactModel {
  final int id;
  final String name;
  final String role;
  final DateTime? lastMessageDate;

  ContactModel({
    required this.id,
    required this.name,
    required this.role,
    required this.lastMessageDate,
  });

  factory ContactModel.fromJson(json) {
    return ContactModel(
      id: json["id"],
      name: json["name"],
      role: json["role"],
      lastMessageDate: DateTime.tryParse(json["lastMessageDate"].toString()),
    );
  }
}
