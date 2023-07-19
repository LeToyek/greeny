import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SchedulePickerNotifier extends StateNotifier<int> {
  SchedulePickerNotifier() : super(0);

  void getSchedule(context, Widget text, Widget spinner) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Pilih Penjadwalan"),
          content: SizedBox(
            height: 200,
            child: Column(
              children: [text, spinner],
            ),
          ),
        );
      },
    );
  }

  void setSchedule(int index) {
    if (index > 0) {
      state = index;
    }
  }

  void resetSchedule() => state = 0;
}

final schedulePickerProvider =
    StateNotifierProvider<SchedulePickerNotifier, int>((ref) {
  return SchedulePickerNotifier();
});
