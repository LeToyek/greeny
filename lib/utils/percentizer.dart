import 'package:greenify/constants/level_list.dart';

double percentizer(int value, int valLevel) {
  final expNeed =
      levelList.where((element) => element.level == valLevel).first.exp;
  final expNow = value;
  int totalDigits = value.toString().length;
  double percentage = value.toDouble();
  for (var i = 0; i < totalDigits; i++) {
    percentage /= 10;
  }
  return percentage;
}
