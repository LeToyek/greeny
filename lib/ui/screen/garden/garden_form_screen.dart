import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/states/file_notifier.dart';
import 'package:greenify/states/plant_avatar_state.dart';
import 'package:greenify/states/scheduler/schedule_picker_state.dart';
import 'package:greenify/states/scheduler/time_picker_state.dart';
import 'package:greenify/states/theme_mode.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:greenify/ui/widgets/numberpicker.dart';
import 'package:greenify/ui/widgets/upload_image_container.dart';
import 'package:ionicons/ionicons.dart';
final List<Map<String, dynamic>> _characterImages = [
  {
    "image": 'https://img.freepik.com/free-vector/plant-emoji_78370-262.jpg',
    "name": "Sayuran"
  },
  {
    "image":
        'https://friendlystock.com/wp-content/uploads/2020/12/3-kawaii-indoor-plant-cartoon-clipart.jpg',
    "name": "Bunga"
  },
  {
    "image": 'https://img.freepik.com/free-vector/plant-emoji_78370-262.jpg',
    "name": "Sayuran"
  },
  {
    "image": 'https://img.freepik.com/free-vector/plant-emoji_78370-262.jpg',
    "name": "Sayuran"
  },
  {
    "image": 'https://img.freepik.com/free-vector/plant-emoji_78370-262.jpg',
    "name": "Sayuran"
  },
  {
    "image": 'https://img.freepik.com/free-vector/plant-emoji_78370-262.jpg',
    "name": "Sayuran"
  },
];

class GardenFormScreen extends ConsumerWidget {
  const GardenFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = ref.watch(plantAvatarProvider);

    final themeController = ref.watch(themeProvider);
    final fileController = ref.read(fileProvider.notifier);

    final scheduleController = ref.watch(schedulePickerProvider);
    final funcScheduleController = ref.read(schedulePickerProvider.notifier);

    final timeController = ref.watch(timePickerProvider);
    final funcTimeController = ref.read(timePickerProvider.notifier);

    final textTheme = Theme.of(context).textTheme;
    return NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              title: const Text("Tambah Tanaman"),
              pinned: true,
              floating: true,
              snap: true,
              forceElevated: innerBoxIsScrolled,
            )
          ];
        },
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Material(
            color: Theme.of(context).colorScheme.background,
            child: Card(
              margin: const EdgeInsets.all(16),
              elevation: 2,
              shadowColor: Theme.of(context).colorScheme.shadow,
              color: Theme.of(context).colorScheme.surface,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12))),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Kategori",
                            style: textTheme.titleMedium!
                                .apply(fontWeightDelta: 2),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            "Pilihlah kategori yang sesuai untuk tanaman anda",
                            style:
                                textTheme.bodyMedium!.apply(color: Colors.grey),
                            textAlign: TextAlign.start,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          _plantChoose(pageController, context, ref),
                          _platFormField(
                              "Nama", "Masukkan nama tanaman", context),
                          const SizedBox(height: 16),
                          Text(
                            "Jadwal Penyiraman",
                            style: textTheme.titleMedium!
                                .apply(fontWeightDelta: 2),
                          ),
                          Text(
                              "Anda akan diingatkan untuk menyiram tanaman melalui notifikasi",
                              style: textTheme.bodyMedium!
                                  .apply(color: Colors.grey)),
                          const SizedBox(
                            height: 8,
                          ),
                          _wateringSchedule(
                              context,
                              scheduleController,
                              funcScheduleController,
                              timeController,
                              funcTimeController),
                          const SizedBox(height: 16),
                          Text(
                            "Gambar Tanaman",
                            style: textTheme.titleMedium!
                                .apply(fontWeightDelta: 2),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          UploadImageContainer(
                            fileNotifier: fileController,
                          ),
                          const SizedBox(
                            height: 16,
                          ),
                          GestureDetector(
                            onTap: () async {
                              // await AndroidAlarmManager.periodic(
                              //   const Duration(seconds: 30),
                              //   1,
                              //   BackgroundServices.callback,
                              //   startAt: DateTime.now(),
                              //   exact: true,
                              //   wakeup: true,
                              // );
                            },
                            child: PlainCard(
                                color: Theme.of(context).colorScheme.primary,
                                child: Center(
                                  child: Text(
                                    "Tambahkan Tanaman",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .apply(
                                            fontWeightDelta: 2,
                                            color: Colors.white),
                                  ),
                                )),
                          )
                        ])),
              ),
            ),
          ),
        ));
  }

  Widget _wateringSchedule(
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
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .apply(
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

  Widget _platFormField(String label, String hint, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: Theme.of(context).textTheme.titleMedium!.apply(
                  fontWeightDelta: 2,
                )),
        const SizedBox(height: 8.0),
        TextFormField(
          validator: (value) =>
              value!.trim().isEmpty ? "Masukkan $label" : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: Theme.of(context).textTheme.bodyMedium!.apply(
                  color: Colors.grey,
                ),
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _plantChoose(
      PageController pageController, BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    return Row(
      children: [
        InkWell(
            onTap: () {
              if (pageController.page! > 0) {
                pageController.previousPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut);
              } else {
                pageController.animateToPage(_characterImages.length - 1,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut);
              }
            },
            child: Icon(
              Ionicons.chevron_back_outline,
              color: theme != ThemeMode.light
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onBackground,
            )),
        Expanded(
          child: SizedBox(
            height: 210,
            child: PageView.builder(
              physics: const NeverScrollableScrollPhysics(),
              controller: pageController,
              itemCount: _characterImages.length,
              itemBuilder: (context, index) {
                return AnimatedBuilder(
                  animation: pageController,
                  builder: (context, child) {
                    double value = 1;
                    if (pageController.position.haveDimensions) {
                      value = pageController.page! - index;
                      value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
                    }
                    return Center(
                      child: SizedBox(
                        height: Curves.easeOut.transform(value) * 210,
                        width: Curves.easeOut.transform(value) * 210,
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      SizedBox(
                        height: 130,
                        child: Image.network(
                          _characterImages[index]["image"],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Text(
                        _characterImages[index]["name"],
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall!
                            .apply(fontWeightDelta: 2),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ),
        InkWell(
            onTap: () {
              if (pageController.page! < _characterImages.length - 1) {
                pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut);
              } else {
                pageController.animateToPage(0,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOut);
              }
            },
            child: Icon(
              Ionicons.chevron_forward_outline,
              color: theme != ThemeMode.light
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onBackground,
            )),
      ],
    );
  }
}
