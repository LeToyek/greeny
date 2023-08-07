import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:greenify/model/notification_model.dart';
import 'package:rxdart/rxdart.dart';

final selectNotificationSubject = BehaviorSubject<String?>();
final didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();

class NotificationHelper {
  static const _channelID = "01";
  static const _channelName = "channel_01";
  static const _channelDescription = "Greenify Channel";
  static NotificationHelper? _instance;

  NotificationHelper._internal() {
    _instance = this;
  }

  factory NotificationHelper() => _instance ?? NotificationHelper._internal();

  Future<void> initializeNotification() async {
    await flutterLocalNotificationsPlugin.initialize(initializeSettings);
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');
      if (message.notification != null) {
        print(
            'Message also contained a notification: ${message.notification!.body}');
      }
      showNotification(
          id: 1,
          title: message.data['title'],
          body: message.data['body'],
          payload: "test");
    });
  }
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

const initializeSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'));

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message ${message.messageId}');
}

Future<void> showNotification(
    {required id,
    required String title,
    required String body,
    required String payload}) async {
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel id', 'channel name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'test ticker');

  var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin
      .show(id, title, body, platformChannelSpecifics, payload: payload);
}

void scheduleNotification() {
  var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel id', 'channel name',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'test ticker');

  var platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  flutterLocalNotificationsPlugin.periodicallyShow(0, 'scheduled title',
      'scheduled body', RepeatInterval.everyMinute, platformChannelSpecifics);
}
