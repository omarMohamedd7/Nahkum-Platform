import 'package:get_storage/get_storage.dart';

GetStorage cache = GetStorage();

class CacheHelper {
  static const String token = 'token';
  static const String user = 'user';
  static const String fcmToken = 'fcm_token';
  static const String notificationsEnabled = 'notificationsEnabled';
  static logout() {
    cache.remove(token);
    cache.remove(user);
  }
}
