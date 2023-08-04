import 'package:greenify/utils/number_parser.dart';

class HeightModel {
  int height;
  String date;

  HeightModel({required this.height, required this.date});

  HeightModel.fromQuery(Map<String, dynamic> json)
      : height = NumberParser.getNumber(json['height'].toString()),
        date = json['date'];

  Map<String, dynamic> toQuery() {
    return {
      "height": height,
      "date": date,
    };
  }
}
