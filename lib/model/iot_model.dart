// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:greenify/utils/formatter.dart';

class IOTSystem {
  final IOTModel pump;
  final IOTModel humidifier;
  final AirHumidifierSensor airHumidifierSensor;
  final SoilHumiditySensor soilHumidifierSensor;

  IOTSystem({
    required this.pump,
    required this.humidifier,
    required this.airHumidifierSensor,
    required this.soilHumidifierSensor,
  });

  factory IOTSystem.fromMap(Map<String, dynamic> map) {
    return IOTSystem(
      pump: IOTModel.fromMap(map['pump']),
      humidifier: IOTModel.fromMap(map['humidifier']),
      airHumidifierSensor:
          AirHumidifierSensor.fromMap(map['airHumidifierSensor']),
      soilHumidifierSensor:
          SoilHumiditySensor.fromMap(map['soilHumidifierSensor']),
    );
  }
}

class IOTModel {
  final String id;
  final int isOn;
  final String lastChanged;
  IOTModel({
    required this.id,
    required this.isOn,
    required this.lastChanged,
  });
  factory IOTModel.fromMap(Map<String, dynamic> map) {
    print("map $map");
    return IOTModel(
      id: map['id'],
      isOn: map['isOn'],
      lastChanged: map['lastChanged'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'isOn': isOn,
      'lastChanged': lastChanged,
    };
  }
}

class AirHumidifierSensor extends IOTModel {
  int humidityVal;
  double temperatureC;
  double temperatureF;

  AirHumidifierSensor({
    required this.humidityVal,
    required this.temperatureC,
    required this.temperatureF,
    required String id,
    required int isOn,
    required String lastChanged,
  }) : super(id: id, isOn: isOn, lastChanged: lastChanged);

  factory AirHumidifierSensor.fromMap(Map<String, dynamic> map) {
    return AirHumidifierSensor(
      humidityVal: checkInt(map['humidity']),
      temperatureC: checkDouble(map['temperature']['celcius']),
      temperatureF: checkDouble(map['temperature']['fahrenheit']),
      id: map['id'],
      isOn: checkInt(map['isOn']),
      lastChanged: map['lastChanged'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    // TODO: implement toMap
    return {
      'humidityVal': humidityVal,
      'temperatureC': temperatureC,
      'temperatureF': temperatureF,
      'id': id,
      'isOn': isOn,
      'lastChanged': lastChanged,
    };
  }
}

class SoilHumiditySensor extends IOTModel {
  int humidityVal;

  SoilHumiditySensor({
    required this.humidityVal,
    required String id,
    required int isOn,
    required String lastChanged,
  }) : super(id: id, isOn: isOn, lastChanged: lastChanged);

  factory SoilHumiditySensor.fromMap(Map<String, dynamic> map) {
    return SoilHumiditySensor(
      humidityVal: map['val'],
      id: map['id'],
      isOn: checkInt(map['isOn']),
      lastChanged: map['lastChanged'],
    );
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'humidityVal': humidityVal,
      'id': id,
      'isOn': isOn,
      'lastChanged': lastChanged,
    };
  }
}
