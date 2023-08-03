class HeightModel {
  double height;
  String date;

  HeightModel({required this.height, required this.date});

  HeightModel.fromQuery(Map<String, dynamic> json)
      : height = json['height'],
        date = json['date'];

  Map<String, dynamic> toQuery() {
    return {
      "height": height,
      "date": date,
    };
  }
}
