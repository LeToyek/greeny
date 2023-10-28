import 'package:intl/intl.dart';

String trimmer(String text) {
  if (text.length <= 32) {
    return text;
  } else {
    return '${text.substring(0, 32)}...';
  }
}

String formatMoney(int amount) {
  final formatter = NumberFormat('#,###');
  return formatter.format(amount);
}

double checkDouble(dynamic value) {
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? 0;
  return 0;
}

int checkInt(dynamic value) {
  if (value is int) return value;
  if (value is double) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}
