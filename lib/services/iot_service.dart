import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/iot_model.dart';

final iotServiceProvider = Provider<IOTService>((ref) {
  final firebaseDatabase = FirebaseDatabase.instance;

  return IOTServiceImpl(firebaseDatabase);
});

mixin IOTService {
  IOTModel connect();
  void disconnect();
  void turnOnPump(bool isOn);
  void turnOnHumidifier(bool isOn);
}

class IOTServiceImpl implements IOTService {
  final FirebaseDatabase _firebaseDatabase;
  final DatabaseReference pumpRef =
      FirebaseDatabase.instance.ref("/sans1/pump/isOn");
  final DatabaseReference sprayRef =
      FirebaseDatabase.instance.ref("/sans1/spray/isOn");

  IOTServiceImpl(this._firebaseDatabase);

  @override
  IOTModel connect() {
    // TODO: implement connect
    _firebaseDatabase.ref();
    return IOTModel(id: "id", isOn: 1, lastChanged: "lastChanged");
  }

  @override
  void disconnect() {
    // TODO: implement disconnect
  }

  @override
  void turnOnHumidifier(bool isOn) {
    // TODO: implement turnOnHumidifier
    if (isOn) {
      sprayRef.set(1);
    } else {
      sprayRef.set(0);
    }
  }

  @override
  void turnOnPump(bool isOn) {
    // TODO: implement turnOnPump
    if (isOn) {
      pumpRef.set(1);
    } else {
      pumpRef.set(0);
    }
  }
}
