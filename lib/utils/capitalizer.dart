import 'package:intl/intl.dart';

String capitalize(String input) =>
    input.split(' ').map((word) => toBeginningOfSentenceCase(word)).join(' ');

List<String> separatePayload(String payload) {
  List<String> separatedValues = payload.split('/');
  return separatedValues;
}
