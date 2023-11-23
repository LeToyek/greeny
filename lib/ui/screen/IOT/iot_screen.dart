import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/states/iot/iot_notifier.dart';
import 'package:greenify/ui/layout/drawer.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';
import 'package:ionicons/ionicons.dart';

class IOTScreen extends ConsumerStatefulWidget {
  static const String routeName = "iot-control";
  static const String routePath = "/iot/control";

  const IOTScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IOTScreenState();
}

class _IOTScreenState extends ConsumerState<IOTScreen> {
  bool isOnPump = false;
  bool isOnHumidifier = false;
  bool isAuto = false;

  final FirebaseDatabase _database = FirebaseDatabase.instance;

  StreamSubscription? _iotSubscription;

  @override
  void initState() {
    super.initState();

    _iotSubscription =
        _database.ref('sans1').child('is_auto').onValue.listen((event) {
      if (context.mounted && event.snapshot.value != null) {
        _updateAuto(event.snapshot.value as num == 1);
      }
    });
  }

  Future<void> _setAuto(bool value) async {
    setState(() {
      isAuto = value;
    });

    await _database.ref('sans1').child('is_auto').set(value ? 1 : 0);
  }

  Future<void> _updateAuto(bool value) async {
    final iotFunc = ref.read(iotNotifier.notifier);

    setState(() {
      if (value) {
        isOnPump = false;
        isOnHumidifier = false;
        iotFunc.turnPump(2);
        iotFunc.turnSpray(2);
      } else {
        iotFunc.turnPump(0);
        iotFunc.turnSpray(0);
      }
    });
  }

  @override
  void dispose() {
    _iotSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iotRef = ref.watch(iotNotifier);
    final iotFunc = ref.watch(iotNotifier.notifier);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "IOT",
          // style: textTheme.headlineSmall!.apply(fontWeightDelta: 2),
        ),
        centerTitle: true,
      ),
      endDrawer: const GrDrawerr(),
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: iotRef.when(
                loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                error: (error, stack) => Center(
                      child: Text(
                        error.toString(),
                        style: textTheme.bodyMedium!
                            .apply(color: colorScheme.error),
                      ),
                    ),
                data: (data) {
                  return PlainCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Greeny Care",
                          style: textTheme.headlineSmall!
                              .apply(fontWeightDelta: 2),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Image.asset(
                          "assets/images/sayur.png",
                          height: 200,
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        _buildTitle(context,
                            title: "Kondisi Tanaman",
                            content:
                                "Pantau kondisi tanaman secara real time dengan menggunakan sensor IOT"),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildDataCard(context,
                                title: "Udara",
                                content:
                                    "${data.airHumidifierSensor.humidityVal}%",
                                color: Colors.lightBlue,
                                icon: Icons.air_outlined),
                            const SizedBox(
                              width: 16,
                            ),
                            _buildDataCard(context,
                                color: Colors.deepOrange,
                                title: "Suhu",
                                content:
                                    "${data.airHumidifierSensor.temperatureC}°C",
                                icon: Icons.thermostat),
                            const SizedBox(
                              width: 16,
                            ),
                            _buildDataCard(context,
                                title: "Tanah",
                                content:
                                    "${data.soilHumidifierSensor.humidityVal}",
                                icon: Icons.grass),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        _buildTitle(context,
                            title: "Kontrol IOT",
                            content:
                                "Tekan tombol untuk mengontrol perangkat IOT"),
                        const SizedBox(
                          height: 16,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildDataCard(context,
                                title: "Pompa Air",
                                onTap: isAuto
                                    ? () => showUnableToTurnIOT(context)
                                    : () {
                                        setState(() {
                                          isOnPump = !isOnPump;
                                        });
                                        iotFunc.turnPump(isOnPump ? 1 : 0);
                                      },
                                content: isOnPump ? "ON" : "OFF",
                                color: isOnPump
                                    ? colorScheme.primary
                                    : colorScheme.primary.withOpacity(0.3),
                                icon: Icons.water),
                            const SizedBox(
                              width: 16,
                            ),
                            _buildDataCard(context,
                                title: "Humidifier",
                                content: isOnHumidifier ? "ON" : "OFF",
                                onTap: isAuto
                                    ? () => showUnableToTurnIOT(context)
                                    : () {
                                        setState(() {
                                          isOnHumidifier = !isOnHumidifier;
                                        });
                                        iotFunc
                                            .turnSpray(isOnHumidifier ? 1 : 0);
                                      },
                                color: isOnHumidifier
                                    ? colorScheme.primary
                                    : colorScheme.primary.withOpacity(0.3),
                                icon: Icons.lightbulb),
                          ],
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        _buildTitle(context,
                            title: "Otomatisasi IOT dengan AI",
                            content:
                                "Aktifkan otomatisasi IOT dengan AI untuk mengontrol perangkat IOT secara otomatis"),
                        const SizedBox(
                          height: 16,
                        ),
                        ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                  width: 1, color: colorScheme.primary)),
                          leading: Icon(
                            Ionicons.sparkles,
                            color: colorScheme.primary,
                          ),
                          title: Text(
                            "Otomatisasi IOT (AI)",
                            style:
                                textTheme.labelLarge!.apply(fontWeightDelta: 2),
                          ),
                          trailing: Switch(
                            value: isAuto,
                            onChanged: _setAuto,
                          ),
                        )
                            .animate(
                              onPlay: (c) => c.repeat(reverse: true),
                            )
                            .custom(
                              duration: 1.seconds,
                              builder: (context, value, child) {
                                return DecoratedBox(
                                  decoration: BoxDecoration(
                                      color: colorScheme.surface,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        // breathing shadow
                                        BoxShadow(
                                          color: colorScheme.primary
                                              .withOpacity(0.3),
                                          // map value from 0 to 1 to 0 to 8
                                          blurRadius: 10 * value,
                                          offset: const Offset(0, 0),
                                        ),
                                      ]),
                                  child: child,
                                );
                              },
                            )
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(context,
      {required String title, required String content}) {
    final textTheme = Theme.of(context).textTheme;
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: textTheme.labelLarge!.apply(fontWeightDelta: 2),
          ),
          Text(
            content,
            style: textTheme.labelMedium!.apply(),
          ),
        ],
      ),
    );
  }

  Widget _buildDataCard(context,
      {required String title,
      required String content,
      required IconData icon,
      void Function()? onTap,
      Color? color}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: PlainCard(
          onTap: onTap,
          color: color ?? colorScheme.primary,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge!
                    .apply(fontWeightDelta: 2, color: colorScheme.onPrimary),
              ),
              const SizedBox(
                height: 8,
              ),
              Icon(
                icon,
                size: 32,
                color: colorScheme.onPrimary,
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                content,
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .apply(fontWeightDelta: 2, color: colorScheme.onPrimary),
              ),
            ],
          )),
    );
  }

  void showUnableToTurnIOT(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Akses Ditolak"),
              icon: Icon(Ionicons.warning_outline,
                  color: Theme.of(context).colorScheme.error),
              content: const Text(
                  "Matikan otomatisasi IOT terlebih dahulu untuk mengontrol secara manual"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("OK"))
              ],
            ));
  }
}
