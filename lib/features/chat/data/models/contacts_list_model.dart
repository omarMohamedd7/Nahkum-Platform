import 'package:nahkum/features/chat/data/models/contact_model.dart';

class ContactsModel {
  final List<ContactModel> contacts;

  ContactsModel({required this.contacts});

  factory ContactsModel.fromJson(Map<String, dynamic> json) {
    var availbleCasesList = <ContactModel>[];
    if (json['data']['data'] != null) {
      availbleCasesList = List<ContactModel>.from(
        json['data']['data'].map((post) => ContactModel.fromJson(post)),
      );
    }
    return ContactsModel(contacts: availbleCasesList);
  }
}
