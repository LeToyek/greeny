import 'package:intl/intl.dart';

String capitalize(String input) =>
    input.split(' ').map((word) => toBeginningOfSentenceCase(word)).join(' ');
