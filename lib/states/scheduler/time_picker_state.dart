import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TimePickerNotifier extends StateNotifier<TimeOfDay?> {
  TimePickerNotifier() : super(null);

  Future<void> selectTime(context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      state = pickedTime;
      print(pickedTime);
    }
  }

  void resetTime() => state = null;
}

final timePickerProvider =
    StateNotifierProvider<TimePickerNotifier, TimeOfDay?>((ref) {
  return TimePickerNotifier();
});
