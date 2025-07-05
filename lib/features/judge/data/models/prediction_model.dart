class PredictionModel {
  final String name;
  final String duration;
  final String date;
  final String prediction;
  final double confidence;

  bool get isLier => prediction == '1';
  String get confidencePercentage =>
      " ${(confidence * 100).toStringAsFixed(0)}% ";

  PredictionModel({
    required this.prediction,
    required this.confidence,
    required this.name,
    required this.date,
    required this.duration,
  });

  factory PredictionModel.fromJson(
    Map<String, dynamic> json, {
    bool isList = false,
  }) {
    if (!isList) {
      json = json['data'];
    }
    return PredictionModel(
      prediction: json['prediction'].toString(),
      confidence: (json['confidence'] as num).toDouble(),
      date: json['analysis_date'],
      duration: json['duration'].toString(),
      name: json['video_name'] ?? '',
    );
  }
}
