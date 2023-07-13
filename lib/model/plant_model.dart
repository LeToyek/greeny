import 'package:cloud_firestore/cloud_firestore.dart';

enum PlantStatus { healthy, dry, dead }

class PlantModel {
  String name;
  String description;
  String image;
  String wateringSchedule;
  String wateringTime;
  double height;
  PlantStatus status;
  String category;
  String id;

  PlantModel(
      {required this.name,
      required this.description,
      required this.image,
      required this.wateringSchedule,
      required this.wateringTime,
      required this.height,
      required this.status,
      required this.category,
      required this.id});

  PlantModel.fromQuery(DocumentSnapshot<Object?> json)
      : name = json['name'],
        description = json['description'],
        image = json['image'],
        wateringSchedule = json['watering_schedule'],
        wateringTime = json['watering_time'],
        height = json['height'],
        status = json['status'],
        category = json['category'],
        id = json['id'];

  Map<Object, Object?> toQuery(PlantModel plantModel) {
    return {
      "name": plantModel.name,
      "description": plantModel.description,
      "image": plantModel.image,
      "watering_schedule": plantModel.wateringSchedule,
      "watering_time": plantModel.wateringTime,
      "height": plantModel.height,
      "status": plantModel.status,
      "category": plantModel.category,
      "id": plantModel.id,
    };
  }
}
