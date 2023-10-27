import 'dart:async';
import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/iot_model.dart';
import 'package:greenify/services/iot_service.dart';

typedef IOTState = AsyncValue<IOTSystem>;

final iotNotifier = StateNotifierProvider<IOTNotifier, IOTState>((ref) {
  final service = ref.watch(iotServiceProvider);

  return IOTNotifier(service)..load();
});

class IOTNotifier extends StateNotifier<IOTState> {
  final IOTService _service;
  late StreamSubscription<DatabaseEvent> _onDataAddedSubscription;
  // late final List<Object?> _originalList = [];
  late IOTModel pump;
  late IOTModel spray;
  late AirHumidifierSensor airHumidifierSensor;
  late SoilHumiditySensor soilHumidifierSensor;

  IOTNotifier(this._service) : super(const AsyncLoading());

  Future<void> load() async {
    state = const AsyncValue.loading();
    print("test init");
    final DatabaseReference ref = FirebaseDatabase.instance.ref("/sans1");
    try {
      print("test init");
      _onDataAddedSubscription = ref.onValue.listen((event) {
        final mapValue = jsonDecode(jsonEncode(event.snapshot.value))
            as Map<String, dynamic>;
        print("mapValue $mapValue");

        pump = IOTModel.fromMap(mapValue['pump']);
        spray = IOTModel.fromMap(mapValue['spray']);
        airHumidifierSensor = AirHumidifierSensor.fromMap(mapValue['dht_11']);
        soilHumidifierSensor =
            SoilHumiditySensor.fromMap(mapValue['soil_moisture']);

        print("pump ${pump.id}");
        print("spray ${spray.id}");
        print("airHumidifierSensor ${airHumidifierSensor.id}");
        print("soilHumidifierSensor ${soilHumidifierSensor.id}");

        // print("test run");
        state = AsyncValue.data(IOTSystem(
            pump: pump,
            humidifier: spray,
            airHumidifierSensor: airHumidifierSensor,
            soilHumidifierSensor: soilHumidifierSensor));
      });
    } catch (e, st) {
      print("error $e");
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> turnPump(bool isOn) async {
    _service.turnOnPump(isOn);
  }

  Future<void> turnSpray(bool isOn) async {
    _service.turnOnHumidifier(isOn);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _onDataAddedSubscription.cancel();
    super.dispose();
  }
}
