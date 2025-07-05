import 'package:nahkum/features/lawer/data/models/case_request_model.dart';

class CaseRequestsModel {
  final List<CaseRequestModel> cases;

  CaseRequestsModel({required this.cases});

  factory CaseRequestsModel.fromJson(Map<String, dynamic> json) {
    var cases = <CaseRequestModel>[];
    if (json['data']['data'] != null) {
      cases = List<CaseRequestModel>.from(
        json['data']['data'].map((post) => CaseRequestModel.fromJson(post)),
      );
    }
    return CaseRequestsModel(cases: cases);
  }
}
