import 'dart:isolate';
import 'dart:ui';

import 'package:greenify/utils/notification_helper.dart';

final ReceivePort port = ReceivePort();

class BackgroundServices {
  static BackgroundServices? _instance;
  static const String _isolatname = "isolate";
  static SendPort? _uiSendPort;

  BackgroundServices._internal() {
    _instance = this;
  }

  factory BackgroundServices() => _instance ?? BackgroundServices._internal();

  void initIsolate() {
    IsolateNameServer.registerPortWithName(port.sendPort, _isolatname);
  }

  static Future<void> callback() async {
    String plantName = "";
    String title = "Tanamanmu butuh perhatianmu";
    String body = "Sekarang waktunya untuk menyiram tanamanmu";

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolatname);
    _uiSendPort!.send(null);
    showNotification(id: 1, title: title, body: body, payload: "test");
  }

  void setNotificationMessage() {}

  Future<void> someTask() async {
    print('success send notification');
  }
}
