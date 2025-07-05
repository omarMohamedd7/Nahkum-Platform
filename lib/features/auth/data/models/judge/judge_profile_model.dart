class JudgeProfileModel {
  final int judgeId;
  final String courtName;
  final String specialization;
  final String createdAt;
  final String updatedAt;

  const JudgeProfileModel({
    required this.judgeId,
    required this.courtName,
    required this.specialization,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JudgeProfileModel.fromJson(Map<String, dynamic> json) {
    return JudgeProfileModel(
      judgeId: json['judge_id'] as int,
      courtName: json['court_name'] as String,
      specialization: json['specialization'] as String,
      createdAt: json['created_at'] as String,
      updatedAt: json['updated_at'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'judge_id': judgeId,
      'court_name': courtName,
      'specialization': specialization,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  JudgeProfileModel copyWith({
    int? judgeId,
    String? courtName,
    String? specialization,
    String? createdAt,
    String? updatedAt,
  }) {
    return JudgeProfileModel(
      judgeId: judgeId ?? this.judgeId,
      courtName: courtName ?? this.courtName,
      specialization: specialization ?? this.specialization,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
