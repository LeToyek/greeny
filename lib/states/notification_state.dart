import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:greenify/services/background_service.dart';
import 'package:greenify/utils/notification_helper.dart';
import 'package:hive/hive.dart';
import 'package:riverpod/riverpod.dart';

final BackgroundServices _backgroundServices = BackgroundServices();

class NotificationNotifier extends StateNotifier<void> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  NotificationNotifier()
      : super(port.listen((_) async {
          await _backgroundServices.someTask();
        }));

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    selectNotificationSubject.close();
    didReceiveLocalNotificationSubject.close();
  }

  Future<void> initRealNotification() async {
    final box = Hive.box('prefs');
    final statusNotifier = box.get('status_notifier', defaultValue: 0);
    if (statusNotifier == 0) {
      box.put('status_notifier', 1);
      await AndroidAlarmManager.oneShot(
          Duration.zero, 99999999, BackgroundServices.initCallback);
    }
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, void>((ref) {
  return NotificationNotifier()..initRealNotification();
});
