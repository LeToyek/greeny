import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/constants/plant_category_list.dart';
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

class GardenFormScreen extends ConsumerStatefulWidget {
  final String id;
  const GardenFormScreen({super.key, required this.id});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GardenFormScreenState();
}

class _GardenFormScreenState extends ConsumerState<GardenFormScreen> {
  late TextEditingController nameController;
  late TextEditingController deskripsiController;

  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;

  final _expValue = 300;
  final achievementId = ["23UcfevnxkIp3J5sUSAz", "e39lg5J9nGZqfnUgi0zN"];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController();
    deskripsiController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController.dispose();
    deskripsiController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pageController = ref.watch(plantAvatarProvider);
    final pageNotifier = ref.read(plantAvatarProvider.notifier);

    final fileController = ref.read(fileProvider.notifier);

    final scheduleController = ref.watch(schedulePickerProvider);
    final funcScheduleController = ref.read(schedulePickerProvider.notifier);

    final timeController = ref.watch(timePickerProvider);
    final funcTimeController = ref.read(timePickerProvider.notifier);

    final potController = ref.read(singlePotProvider(widget.id).notifier);
    final potRef = ref.watch(singlePotProvider(widget.id));

    final potSpaceController = ref.read(potProvider(widget.id).notifier);

    final expController = ref.read(expProvider.notifier);

    Future<void> _submitForm() async {
      if (!_formKey.currentState!.validate()) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Processing Data')));
      } else {
        if (timeController == null || scheduleController == 0) {
          showDialog(
              context: context,
              builder: (_) => AlertDialog(
                    icon: const Icon(Icons.warning),
                    iconColor: Colors.orange.shade300,
                    title: const Text("Perhatian"),
                    backgroundColor: Theme.of(context).colorScheme.background,
                    content: const Text(
                        "Mohon isi jadwal penyiraman dan waktu penyiraman"),
                  ));
          return;
        }
        var realHour = timeController.hour.toString();
        var realMinute = timeController.minute.toString();
        if (realMinute.length == 1) {
          realMinute = "0$realMinute";
        }
        if (realHour.length == 1) {
          realHour = "0$realHour";
        }
        String name = nameController.text;
        String description = deskripsiController.text;
        String wateringSchedule = scheduleController.toString();
        String wateringTime = "$realHour:$realMinute";
        double height = 0;
        PlantStatus status = PlantStatus.dry;
        String category = plantCategory[pageController.page!.toInt()]["name"];

        showDialog(
            context: context,
            builder: (context) => isLoading
                ? const CircularProgressIndicator()
                : AlertDialog(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    title: const Text("Konfirmasi"),
                    content: const Text(
                        "Apakah anda yakin ingin menambah tanaman ini?"),
                    actions: [
                      TextButton(
                          onPressed: () => context.pop(),
                          child: const Text("Batal")),
                      TextButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            String image = await fileController.uploadFile();
                            final randInt = Random().nextInt(100000);
                            String potCreatedId = await potController.createPot(
                                PotModel(
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
                                        category: category,
                                        timeID: randInt)));
                            DateTime now = DateTime.now();
                            DateTime tomorrow = DateTime(
                              now.year,
                              now.month,
                              now.day + 1,
                              timeController.hour,
                              timeController.minute,
                            );
                            // await AndroidAlarmManager.oneShotAt(tomorrow, randInt,
                            //     () {
                            //   showNotification(
                            //       id: randInt,
                            //       title: "Pengingat Menyiram",
                            //       body:
                            //           "$name butuh air, jangan lupa siram tanamanmu kawan",
                            //       payload: "${widget.id}/$potCreatedId");
                            // });
                            // await AndroidAlarmManager.periodic(
                            //   const Duration(seconds: 5),
                            //   0,
                            //   () => BackgroundServices.callback(
                            //       title: "$name butuh air",
                            //       body:
                            //           "Tanamanmu sedang butuh air, siram sekarang agar tidak kekeringan"),
                            //   startAt: DateTime.now(),
                            //   exact: true,
                            //   wakeup: true,
                            // );
                            expController.increaseExp(_expValue, achievementId);
                            funcScheduleController.resetSchedule();
                            funcTimeController.resetTime();
                            setState(() {
                              isLoading = false;
                            });
                            if (context.mounted) {
                              potSpaceController.getPots();
                              context.pop();
                              context.pop();
                            }
                          },
                          child: const Text("Ya")),
                    ],
                  ));
      }
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
                      padding: EdgeInsets.only(
                          top: 16,
                          left: 16,
                          right: 16,
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          key: _formKey,
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
                                  height: 16,
                                ),
                                plantChoose(
                                  pageController,
                                  pageNotifier,
                                  context,
                                  ref,
                                ),
                                platFormField(
                                    label: "Nama",
                                    hint: "Masukkan nama tanaman",
                                    context: context,
                                    nameController: nameController,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return "Nama tidak boleh kosong";
                                      }
                                      return null;
                                    }),
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
                                  height: 16,
                                ),
                                UploadImageContainer(
                                  fileNotifier: fileController,
                                ),
                                const SizedBox(
                                  height: 16,
                                ),
                                platFormField(
                                    label: "Deskripsi",
                                    hint: "Masukkan deskripsi tanaman",
                                    context: context,
                                    nameController: deskripsiController,
                                    maxLines: 4,
                                    validator: (p0) => null),
                                const SizedBox(
                                  height: 16,
                                ),
                                GestureDetector(
                                  onTap: () async {
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
                                ),
                                const SizedBox(
                                  height: 16,
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
