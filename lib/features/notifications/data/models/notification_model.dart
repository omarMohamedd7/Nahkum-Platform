import 'package:intl/intl.dart';

class NotificationModel {
  final String id;
  final String title;
  final String description;
  final String time;
  final bool isRead;

  NotificationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    this.isRead = false,
  });

  NotificationModel copyWith({
    String? id,
    String? title,
    String? description,
    String? time,
    bool? isRead,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      isRead: isRead ?? this.isRead,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'time': time,
      'isRead': isRead,
    };
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    final rawDate = json['created_at'];
    String formattedDate = '';
    if (rawDate != null) {
      final dateTime = DateTime.parse(rawDate).toLocal();
      formattedDate = DateFormat('dd-MM-yyyy hh:mm a').format(dateTime);
    }

    return NotificationModel(
      id: json['id'],
      title: json['type'],
      description: json['message'],
      time: formattedDate,
      isRead: json['isRead'] ?? false,
    );
  }
}
