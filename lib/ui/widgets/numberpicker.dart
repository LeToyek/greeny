import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/states/scheduler/schedule_picker_state.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:numberpicker/numberpicker.dart';

class GreenNumberPicker extends StatefulWidget {
  final SchedulePickerNotifier schedulePickerNotifier;
  const GreenNumberPicker({super.key, required this.schedulePickerNotifier});

  @override
  State<GreenNumberPicker> createState() => _GreenNumberPickerState();
}

class _GreenNumberPickerState extends State<GreenNumberPicker> {
  @override
  int _currentIntValue = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        const SizedBox(height: 16),
        Text('Jadwal Penyiraman',
            style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text("Tentukan berapa kali sehari tanaman anda disiram",
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center),
        const SizedBox(height: 8),
        NumberPicker(
          value: _currentIntValue,
          minValue: 1,
          maxValue: 20,
          step: 1,
          haptics: true,
          onChanged: (value) => setState(() => _currentIntValue = value),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.remove,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              onPressed: () => setState(() {
                final newValue = _currentIntValue - 10;
                _currentIntValue = newValue.clamp(0, 100);
              }),
            ),
            Text('$_currentIntValue hari sekali'),
            IconButton(
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.onBackground,
              ),
              onPressed: () => setState(() {
                final newValue = _currentIntValue + 20;
                _currentIntValue = newValue.clamp(0, 100);
              }),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            widget.schedulePickerNotifier.setSchedule(_currentIntValue);
            context.pop();
          },
          child: PlainCard(
              color: Theme.of(context).colorScheme.primary,
              child: Text(
                "Tetapkan",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .apply(fontWeightDelta: 2, color: Colors.white),
              )),
        )
      ],
    );
  }
}
