import 'package:nahkum/features/judge/data/models/task_model.dart';

class TasksModel {
  final List<TaskModel> data;

  TasksModel({
    required this.data,
  });

  factory TasksModel.fromJson(Map<String, dynamic> json) {
    return TasksModel(
      data: List<TaskModel>.from(
        json['data']['data'].map((x) => TaskModel.fromJson(x)),
      ),
    );
  }
}
