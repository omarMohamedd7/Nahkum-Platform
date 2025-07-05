import 'package:get/get.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/features/notifications/data/models/notification_model.dart';
import 'package:nahkum/features/notifications/data/repo/notifications_repo.dart';

class NotificationsController extends GetxController {
  NotificationsRepo notificationsRepo = NotificationsRepo();

  final RxBool isLoading = false.obs;

  RxList<NotificationModel> notifications = <NotificationModel>[].obs;

  @override
  Future<void> onInit() async {
    super.onInit();
    getNotifications();
  }

  Future<void> getNotifications() async {
    isLoading(true);
    final result = await notificationsRepo.getNotifications();
    if (result is DataSuccess) {
      notifications.value = result.data!.notifications;
    }
    isLoading(false);
  }
}
