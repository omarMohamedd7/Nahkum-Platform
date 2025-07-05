import 'package:nahkum/features/lawer/data/models/case_model.dart';

class MyCasesModel {
  final List<CaseModel> myCases;

  MyCasesModel({required this.myCases});

  factory MyCasesModel.fromJson(Map<String, dynamic> json) {
    var myCasesList = <CaseModel>[];
    if (json['data'] != null) {
      myCasesList = List<CaseModel>.from(
        json['data'].map((post) => CaseModel.fromJson(post)),
      );
    }
    return MyCasesModel(myCases: myCasesList);
  }
}
