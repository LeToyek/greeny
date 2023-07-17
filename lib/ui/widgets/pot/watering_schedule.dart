import 'package:flutter/material.dart';
import 'package:greenify/states/scheduler/schedule_picker_state.dart';
import 'package:greenify/states/scheduler/time_picker_state.dart';
import 'package:greenify/ui/widgets/numberpicker.dart';
import 'package:ionicons/ionicons.dart';

Widget wateringSchedule(
    context,
    int schedule,
    SchedulePickerNotifier scheduleNotifier,
    TimeOfDay? val,
    TimePickerNotifier timeController) {
  return Row(
    children: [
      Expanded(
          child: GestureDetector(
        onTap: () {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    content: GreenNumberPicker(
                        schedulePickerNotifier: scheduleNotifier),
                  ));
        },
        child: schedule == 0
            ? Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: const Icon(
                  Ionicons.alarm_outline,
                  color: Colors.white,
                ),
              )
            : Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "setiap ${schedule.toString()} hari",
                      style: Theme.of(context).textTheme.bodyMedium!.apply(
                          color: Colors.white,
                          fontWeightDelta: 2,
                          fontSizeDelta: 4),
                    ),
                  ],
                ),
              ),
      )),
      const SizedBox(
        width: 8,
      ),
      Expanded(
        child: GestureDetector(
            onTap: () {
              timeController.selectTime(context);
            },
            child: val == null
                ? Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: const Icon(
                      Ionicons.alarm_outline,
                      color: Colors.white,
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          val.format(context),
                          style: Theme.of(context).textTheme.bodyMedium!.apply(
                              color: Colors.white,
                              fontWeightDelta: 2,
                              fontSizeDelta: 4),
                        ),
                      ],
                    ),
                  )),
      ),
    ],
  );
}
