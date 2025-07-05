import 'package:nahkum/features/lawer/data/models/published_case_model.dart';

class AvailbleCasesModel {
  final List<PublishedCaseModel> availbleCases;

  AvailbleCasesModel({required this.availbleCases});

  factory AvailbleCasesModel.fromJson(Map<String, dynamic> json) {
    var availbleCasesList = <PublishedCaseModel>[];
    if (json['data']['data'] != null) {
      availbleCasesList = List<PublishedCaseModel>.from(
        json['data']['data'].map((post) => PublishedCaseModel.fromJson(post)),
      );
    }
    return AvailbleCasesModel(availbleCases: availbleCasesList);
  }
}
