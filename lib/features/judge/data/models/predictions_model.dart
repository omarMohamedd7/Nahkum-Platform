import 'package:nahkum/features/judge/data/models/prediction_model.dart';

class PredictionsModel {
  final List<PredictionModel> data;

  PredictionsModel({
    required this.data,
  });

  factory PredictionsModel.fromJson(Map<String, dynamic> json) {
    return PredictionsModel(
      data: List<PredictionModel>.from(
        json['data'].map((x) => PredictionModel.fromJson(x, isList: true)),
      ),
    );
  }
}
