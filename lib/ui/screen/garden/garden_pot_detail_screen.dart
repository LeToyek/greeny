import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/constants/plant_category_list.dart';
import 'package:greenify/states/exp_state.dart';
import 'package:greenify/states/file_notifier_state.dart';
import 'package:greenify/states/home_state.dart';
import 'package:greenify/states/plant_avatar_state.dart';
import 'package:greenify/states/pot_state.dart';
import 'package:greenify/states/scheduler/schedule_picker_state.dart';
import 'package:greenify/states/scheduler/time_picker_state.dart';
import 'package:greenify/states/users_state.dart';
import 'package:greenify/ui/widgets/charts/detail_plant_progress_chart.dart';
import 'package:greenify/ui/widgets/pills/plant_status_pills.dart';
import 'package:greenify/ui/widgets/pot/watering_schedule.dart';
import 'package:greenify/ui/widgets/watering_dialog.dart';
import 'package:ionicons/ionicons.dart';

class GardenPotDetailScreen extends ConsumerStatefulWidget {
  final String gardenID;
  final String potID;
  const GardenPotDetailScreen(
      {super.key, required this.gardenID, required this.potID});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _GardenPotDetailScreenState();
}

class _GardenPotDetailScreenState extends ConsumerState<GardenPotDetailScreen> {
  late TextEditingController nameController;

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
    final pageNotifier = ref.watch(plantAvatarProvider.notifier);
    final fileController = ref.read(fileEditProvider.notifier);

    final scheduleController = ref.watch(schedulePickerProvider);
    final funcScheduleController = ref.read(schedulePickerProvider.notifier);

    final timeController = ref.watch(timePickerProvider);
    final funcTimeController = ref.read(timePickerProvider.notifier);

    final potController = ref.read(potProvider(widget.gardenID).notifier);
    final potRef = ref.watch(potProvider(widget.gardenID));

    final color = Theme.of(context).colorScheme;
    final userClientController = ref.read(userClientProvider.notifier);

    final expNotifier = ref.read(expProvider.notifier);

    final textTheme = Theme.of(context).textTheme;

    final homeNotifier = ref.read(homeProvider.notifier);

    int waterExp = 20;
    List<String> achievementIDs = [
      "cWmOltw7SolOmbm1akM5",
      "RL7wKvRiysNsPhUEjG2z"
    ];
    var appBarHeight = AppBar().preferredSize.height;

    return potRef.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text(error.toString())),
        data: (data) {
          final pot = data.first;
          int counterHeight = pot.plant.heightStat!.last.height;
          return WillPopScope(
            onWillPop: () async {
              potController.turnBackData();
              context.pop();
              return false;
            },
            child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 200,
                      pinned: true,
                      actions: [
                        !userClientController.isSelf()
                            ? Container()
                            : PopupMenuButton(
                                offset: Offset(0.0, appBarHeight),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(8.0),
                                    bottomRight: Radius.circular(8.0),
                                    topLeft: Radius.circular(8.0),
                                    topRight: Radius.circular(8.0),
                                  ),
                                ),
                                color: color.surface,
                                itemBuilder: (context) => [
                                      _buildPopupMenuItem(
                                          text: "Matikan Notifikasi",
                                          icon:
                                              Ionicons.notifications_off_circle,
                                          content:
                                              "Anda tidak akan mendapat notifikasi penyiraman tanaman ini lagi",
                                          position: 0,
                                          additionalActions: [
                                            TextButton(
                                                onPressed: () async {
                                                  await AndroidAlarmManager
                                                      .cancel(
                                                          pot.plant.timeID!);
                                                },
                                                child: const Text("Matikan"))
                                          ]),
                                      _buildPopupMenuItem(
                                          text: "Edit Tanaman",
                                          icon: Ionicons.pencil_outline,
                                          content:
                                              "Ubah detail informasi tanaman ini",
                                          position: 1,
                                          additionalActions: [
                                            TextButton(
                                                onPressed: () {
                                                  fileController.imageUrl =
                                                      pot.plant.image;
                                                  context.pop();
                                                  context.push(
                                                      '/garden/${widget.gardenID}/plant/edit',
                                                      extra: {
                                                        "pot": pot,
                                                        "pageNotifier":
                                                            pageNotifier,
                                                      });
                                                },
                                                child: const Text("Ubah"))
                                          ]),
                                      _buildPopupMenuItem(
                                          text: "Hapus Tanaman",
                                          icon: Ionicons.trash_bin_outline,
                                          content:
                                              "Tanaman anda akan dihapus secara permanen",
                                          position: 2,
                                          additionalActions: [
                                            TextButton(
                                                onPressed: () {
                                                  potController
                                                      .deletePot(widget.potID);
                                                  homeNotifier.getPots();
                                                  context.pop();
                                                  context.pop();
                                                },
                                                child: const Text("Hapus")),
                                          ],
                                          isDelete: true),
                                    ])
                      ],
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: Text(
                          pot.plant.name,
                          style: textTheme.titleLarge!
                              .apply(color: Colors.white, fontWeightDelta: 2),
                        ),
                        background: Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            Image.network(
                              pot.plant.image,
                              fit: BoxFit.cover,
                            ),
                            const DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment(0.0, 0.5),
                                  end: Alignment(0.0, 0.0),
                                  colors: <Color>[
                                    Color(0x60000000),
                                    Color(0x00000000),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      leading: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          potController.turnBackData();
                          context.pop();
                        },
                      ),
                    ),
                  ];
                },
                body: Material(
                    color: Theme.of(context).colorScheme.surface,
                    child: CustomScrollView(
                      slivers: [
                        SliverList(
                            delegate: SliverChildListDelegate([
                          const SizedBox(
                            height: 16,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                !userClientController.isSelf()
                                    ? Container()
                                    : Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: const BoxDecoration(
                                            color: Colors.transparent,
                                            shape: BoxShape.circle),
                                        child: const Icon(
                                          Ionicons.water_outline,
                                          color: Colors.transparent,
                                        )),
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: color.primary,
                                  child: CircleAvatar(
                                      radius: 45,
                                      backgroundColor: color.background,
                                      child: Image.asset(
                                        plantCategory.firstWhere((element) =>
                                            element['name'] ==
                                            pot.plant.category)['image'],
                                        height: 80,
                                      )),
                                ),
                                !userClientController.isSelf()
                                    ? Container()
                                    : GestureDetector(
                                        onTap: () {
                                          showWateringDialog(
                                              context: context,
                                              textTheme: textTheme,
                                              counterHeight: counterHeight,
                                              potsNotifier: potController,
                                              isDetail: true,
                                              id: pot.id,
                                              expNotifier: expNotifier,
                                              waterExp: waterExp,
                                              achievementIDs: achievementIDs);
                                        },
                                        child: Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: BoxDecoration(
                                                color: Colors.blue.shade200,
                                                shape: BoxShape.circle),
                                            child: Icon(
                                              Ionicons.water_outline,
                                              color: color.background,
                                            )),
                                      ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // plantChoose(pageController, context, ref,
                                  //     _characterImages),
                                  Text(pot.plant.name,
                                      style: textTheme.titleLarge!
                                          .apply(fontWeightDelta: 2)),

                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      plantHeightPill(
                                          pot.plant.heightStat!.last.height),
                                      const SizedBox(width: 8),
                                      plantStatusPill(pot.plant.status),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    pot.plant.description,
                                    style: textTheme.titleMedium!.apply(
                                        fontWeightDelta: 1, color: Colors.grey),
                                    textAlign: TextAlign.center,
                                  ),
                                ]),
                          ),
                          const SizedBox(
                            height: 4,
                          ),
                          !userClientController.isSelf()
                              ? Container()
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: wateringSchedule(
                                      context,
                                      int.parse(pot.plant.wateringSchedule),
                                      funcScheduleController,
                                      TimeOfDay.fromDateTime(DateTime.parse(
                                          "2021-10-10 ${pot.plant.wateringTime}")),
                                      funcTimeController),
                                ),
                          DetailPlantProgressChart(pot: pot),
                        ])),
                        SliverPadding(
                          padding: const EdgeInsets.all(8.0),
                          sliver: SliverGrid.builder(
                            itemCount: 3,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                            ),
                            itemBuilder: (context, index) => Container(
                              color: Colors.green.shade100,
                              width: 100,
                              height: 100,
                              child: GestureDetector(
                                onTap: () => showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      titlePadding: EdgeInsets.zero,
                                      backgroundColor: Colors.transparent,
                                      iconPadding: EdgeInsets.zero,
                                      insetPadding: EdgeInsets.zero,
                                      buttonPadding: EdgeInsets.zero,
                                      actionsPadding: EdgeInsets.zero,
                                      contentPadding: EdgeInsets.zero,
                                      content: SizedBox(
                                          width: double.infinity,
                                          height: 300,
                                          child: Image.network(
                                            pot.plant.image,
                                            fit: BoxFit.fitWidth,
                                          )),
                                    );
                                  },
                                ),
                                child: Image.network(
                                  pot.plant.image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ))),
          );
        });
  }

  PopupMenuItem _buildPopupMenuItem(
      {required String text,
      required IconData icon,
      required String content,
      required int position,
      bool isDelete = false,
      List<Widget>? additionalActions}) {
    final colorScheme = Theme.of(context).colorScheme;
    return PopupMenuItem(
        onTap: () {
          Future.delayed(
              const Duration(seconds: 0),
              () => showDialog(
                    context: context,
                    builder: (context) => _buildAlertMessage(
                        title: text,
                        content: content,
                        additionalActions: additionalActions),
                  ));
        },
        value: position,
        child: Row(
          children: [
            Icon(
              icon,
              color: isDelete ? colorScheme.error : colorScheme.onSurface,
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              text,
              style: TextStyle(
                  color: isDelete ? colorScheme.error : colorScheme.onSurface),
            ),
          ],
        ));
  }

  AlertDialog _buildAlertMessage(
      {required String title,
      required String content,
      List<Widget>? additionalActions}) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(onPressed: () => context.pop(), child: const Text("Batal")),
        ...additionalActions ?? [],
      ],
    );
  }
}
