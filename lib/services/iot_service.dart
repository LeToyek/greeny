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
  void turnOnPump(int isOn);
  void turnOnHumidifier(int isOn);
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
  void turnOnHumidifier(int isOn) {
    sprayRef.set(isOn);
  }

  @override
  void turnOnPump(int isOn) {
    // TODO: implement turnOnPump
    pumpRef.set(isOn);
  }
}
