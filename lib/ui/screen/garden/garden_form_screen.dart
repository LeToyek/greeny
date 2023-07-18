import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/model/plant_model.dart';
import 'package:greenify/model/pot_model.dart';
import 'package:greenify/states/exp_state.dart';
import 'package:greenify/states/file_notifier.dart';
import 'package:greenify/states/plant_avatar_state.dart';
import 'package:greenify/states/pot_state.dart';
import 'package:greenify/states/scheduler/schedule_picker_state.dart';
import 'package:greenify/states/scheduler/time_picker_state.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:greenify/ui/widgets/pot/plant_choose.dart';
import 'package:greenify/ui/widgets/pot/plant_form_field.dart';
import 'package:greenify/ui/widgets/pot/watering_schedule.dart';
import 'package:greenify/ui/widgets/upload_image_container.dart';

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

class GardenFormScreen extends ConsumerStatefulWidget {
  final String id;
  const GardenFormScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GardenFormScreenState();
}

class _GardenFormScreenState extends ConsumerState<GardenFormScreen> {
  late TextEditingController nameController;

  final _expValue = 300;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageController = ref.watch(plantAvatarProvider);
    final pageNotifier = ref.watch(plantAvatarProvider.notifier);

    final fileController = ref.read(fileProvider.notifier);

    final scheduleController = ref.watch(schedulePickerProvider);
    final funcScheduleController = ref.read(schedulePickerProvider.notifier);

    final timeController = ref.watch(timePickerProvider);
    final funcTimeController = ref.read(timePickerProvider.notifier);

    final potController = ref.read(singlePotProvider(widget.id).notifier);
    final potRef = ref.watch(singlePotProvider(widget.id));

    final expController = ref.read(expProvider.notifier);

    Future<void> _submitForm() async {
      String name = nameController.text;
      String description = "sample Description";
      String wateringSchedule = scheduleController.toString();
      String wateringTime = timeController!.format(context);
      double height = 0;
      PlantStatus status = PlantStatus.healthy;
      String category = _characterImages[pageNotifier.getPage()]["name"];

      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.background,
                title: const Text("Konfirmasi"),
                content:
                    const Text("Apakah anda yakin ingin membuat artikel ini?"),
                actions: [
                  TextButton(
                      onPressed: () => context.pop(),
                      child: const Text("Batal")),
                  TextButton(
                      onPressed: () async {
                        String image = await fileController.uploadFile();
                        potController.createPot(PotModel(
                            status: PotStatus.filled,
                            positionIndex: 0,
                            plant: PlantModel(
                                name: name,
                                description: description,
                                image: image,
                                wateringSchedule: wateringSchedule,
                                wateringTime: wateringTime,
                                height: height,
                                status: status,
                                category: category)));
                        expController.increaseExp(_expValue);
                        if (context.mounted) {
                          context.push("/");
                        }
                      },
                      child: const Text("Ya")),
                ],
              ));
    }

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
        body: potRef.when(
            data: (_) {
              return SingleChildScrollView(
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
                                  style: textTheme.bodyMedium!
                                      .apply(color: Colors.grey),
                                  textAlign: TextAlign.start,
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                                plantChoose(pageController, context, ref,
                                    _characterImages),
                                platFormField("Nama", "Masukkan nama tanaman",
                                    context, nameController),
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
                                wateringSchedule(
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
                                    await _submitForm();
                                  },
                                  child: PlainCard(
                                      color:
                                          Theme.of(context).colorScheme.primary,
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
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(
                  child: Text(err.toString()),
                )));
  }
}
