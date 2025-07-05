import 'package:nahkum/features/notifications/data/models/notification_model.dart';

class NotificationsModel {
  final List<NotificationModel> notifications;

  NotificationsModel({required this.notifications});

  factory NotificationsModel.fromJson(Map<String, dynamic> json) {
    var notificationsList = <NotificationModel>[];
    if (json['data']['notifications'] != null) {
      notificationsList = List<NotificationModel>.from(
        json['data']['notifications']
            .map((post) => NotificationModel.fromJson(post)),
      );
    }
    return NotificationsModel(notifications: notificationsList);
  }
}
