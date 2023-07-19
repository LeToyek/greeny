import 'package:greenify/services/background_service.dart';
import 'package:greenify/utils/notification_helper.dart';
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
}

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, void>((ref) {
  return NotificationNotifier();
});
