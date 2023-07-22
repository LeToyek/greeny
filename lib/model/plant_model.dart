enum PlantStatus { healthy, dry, dead }

class PlantModel {
  String name;
  String description;
  String image;
  String wateringSchedule;
  String wateringTime;
  double height;
  late PlantStatus status;
  String category;
  int? timeID;

  PlantModel(
      {required this.name,
      required this.description,
      required this.image,
      required this.wateringSchedule,
      required this.wateringTime,
      required this.height,
      required this.status,
      required this.category,
      required this.timeID});

  PlantModel.fromQuery(Map<String, dynamic> json)
      : name = json['name'],
        description = json['description'],
        image = json['image'],
        wateringSchedule = json['watering_schedule'],
        wateringTime = json['watering_time'],
        height = json['height'],
        category = json['category'],
        timeID = json['timeID'] {
    status = reverseStatusParse(json['status']);
  }

  PlantStatus reverseStatusParse(String status) {
    switch (status) {
      case "healthy":
        return PlantStatus.healthy;
      case "dry":
        return PlantStatus.dry;
      case "dead":
        return PlantStatus.dead;
      default:
        return PlantStatus.healthy;
    }
  }

  String statusParse(PlantStatus status) {
    switch (status) {
      case PlantStatus.healthy:
        return "healthy";
      case PlantStatus.dry:
        return "dry";
      case PlantStatus.dead:
        return "dead";
      default:
        return "healthy";
    }
  }

  Map<Object, Object?> toQuery() {
    return {
      "name": name,
      "description": description,
      "image": image,
      "watering_schedule": wateringSchedule,
      "watering_time": wateringTime,
      "height": height,
      "status": statusParse(status),
      "category": category,
      "timeID": timeID
    };
  }
}
