class TaskModel {
  final int id;
  final int judgeId;
  final String title;
  final String description;
  final String date;
  final String time;
  final String? taskType;
  final bool? reminderEnabled;
  final String status;
  final bool isOverdue;
  final String createdAt;
  final String updatedAt;

  TaskModel({
    required this.id,
    required this.judgeId,
    required this.title,
    required this.description,
    required this.date,
    required this.time,
    this.taskType,
    this.reminderEnabled,
    required this.status,
    required this.isOverdue,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      judgeId: json['judge_id'],
      title: json['title'],
      description: json['description'],
      date: json['date'],
      time: json['time'],
      taskType: json['task_type'],
      reminderEnabled: json['reminder_enabled'],
      status: json['status'],
      isOverdue: json['is_overdue'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}
