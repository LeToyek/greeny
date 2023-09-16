import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class DateHelper {
  static String getDayFormat(String dateTime) {
    DateTime date = DateTime.parse(dateTime);
    return DateFormat('dd').format(date);
  }

  static DateTime format() {
    // Date and Time Format
    final now = DateTime.now();
    final dateFormat = DateFormat('y/M/d');
    const timeSpecific = "08:00:00";
    final completeFormat = DateFormat('y/M/d H:m:s');

    // Today Format
    final todayDate = dateFormat.format(now);
    final todayDateAndTime = "$todayDate $timeSpecific";
    var resultToday = completeFormat.parseStrict(todayDateAndTime);

    // Tomorrow Format
    var formatted = resultToday.add(const Duration(days: 1));
    final tomorrowDate = dateFormat.format(formatted);
    final tomorrowDateAndTime = "$tomorrowDate $timeSpecific";
    var resultTomorrow = completeFormat.parseStrict(tomorrowDateAndTime);

    return now.isAfter(resultToday) ? resultTomorrow : resultToday;
  }

  static Timestamp parseTimestampString(String timestampStr) {
    // Extract seconds and nanoseconds from the string

    int seconds = int.parse(timestampStr.split(", ")[0].split("=")[1]);
    int nanoseconds = int.parse(
        timestampStr.split(", ")[1].split("=")[1].replaceAll(")", ""));

    // Create and return the Timestamp object
    return Timestamp(seconds, nanoseconds);
  }

  static String timestampToReadable(String rawTime) {
    Timestamp timestamp = parseTimestampString(rawTime);
    DateTime dt = DateTime.fromMillisecondsSinceEpoch(
      timestamp.seconds * 1000 + timestamp.nanoseconds ~/ 1000000,
      isUtc: true,
    );

    // Formatting the date as "21 Juni 2023"
    String formattedDate = "${dt.day} ${_getMonthName(dt.month)} ${dt.year}";
    return formattedDate;
  }

  static String extractDate(String input) {
    // Split the input string by space to separate date and time
    var parts = input.split(' ');

    // The date is the first part
    return parts[0];
  }

  static String extractTime(String input) {
    // Split the input string by space to separate date and time
    var parts = input.split(' ');

    // The time is the second part without seconds and fractional seconds
    var timePart = parts[1].split('.')[0];

    // Extract only the hour and minutes from the time part
    var timeComponents = timePart.split(':');
    var hour = timeComponents[0];
    var minute = timeComponents[1];

    return "$hour:$minute";
  }

  static String _getMonthName(int month) {
    List<String> monthNames = [
      "", // Index 0 not used
      "Januari",
      "Februari",
      "Maret",
      "April",
      "Mei",
      "Juni",
      "Juli",
      "Agustus",
      "September",
      "Oktober",
      "November",
      "Desember",
    ];
    return monthNames[month];
  }
}
