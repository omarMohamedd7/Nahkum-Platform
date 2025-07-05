import 'package:nahkum/core/data/data_service.dart';
import 'package:nahkum/core/data/data_state.dart';
import 'package:nahkum/core/utils/injector.dart';
import 'package:nahkum/features/notifications/data/models/notifications_model.dart';

class NotificationsRepo {
  final DataService _dataService = injector();

  Future<DataState<NotificationsModel>> getNotifications() async {
    return await _dataService.getData(
      endPoint: '/notifications',
      fromJson: NotificationsModel.fromJson,
    );
  }
}
