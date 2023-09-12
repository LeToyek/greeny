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
