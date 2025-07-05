import 'package:nahkum/features/lawer/data/models/case_model.dart';

class CasesModel {
  final List<CaseModel> cases;

  CasesModel({required this.cases});

  factory CasesModel.fromJson(Map<String, dynamic> json) {
    var availbleCasesList = <CaseModel>[];
    if (json['data'] != null) {
      availbleCasesList = List<CaseModel>.from(
        json['data'].map((post) => CaseModel.fromJson(post)),
      );
    }
    return CasesModel(cases: availbleCasesList);
  }
}
