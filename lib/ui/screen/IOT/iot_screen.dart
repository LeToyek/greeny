import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/states/iot/iot_notifier.dart';
import 'package:greenify/ui/layout/drawer.dart';
import 'package:greenify/ui/widgets/card/plain_card.dart';

class IOTScreen extends ConsumerStatefulWidget {
  static const String routeName = "iot";
  static const String routePath = "/iot";
  const IOTScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _IOTScreenState();
}

class _IOTScreenState extends ConsumerState<IOTScreen> {
  bool isOnPump = false;
  bool isOnHumidifier = false;
  @override
  Widget build(BuildContext context) {
    final iotRef = ref.watch(iotNotifier);
    final iotFunc = ref.watch(iotNotifier.notifier);
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Greeny Care",
          // style: textTheme.headlineSmall!.apply(fontWeightDelta: 2),
        ),
        centerTitle: true,
      ),
      endDrawer: const GrDrawerr(),
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: iotRef.when(
              loading: () => const Center(
                    child: CircularProgressIndicator(),
                  ),
              error: (error, stack) => Center(
                    child: Text(
                      error.toString(),
                      style:
                          textTheme.bodyMedium!.apply(color: colorScheme.error),
                    ),
                  ),
              data: (data) {
                return PlainCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Greeny IOT",
                        style:
                            textTheme.headlineSmall!.apply(fontWeightDelta: 2),
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
                                  "${data.soilHumidifierSensor.humidityVal}%",
                              icon: Icons.water),
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
                          _buildDataCard(context, title: "Pompa Air",
                              onTap: () {
                            iotFunc.turnPump(data.pump.isOn == 0);
                            setState(() {
                              isOnPump = data.pump.isOn == 0;
                            });
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
                              onTap: () {
                            iotFunc.turnSpray(data.humidifier.isOn == 0);
                            setState(() {
                              isOnHumidifier = data.humidifier.isOn == 0;
                            });
                          },
                              color: isOnHumidifier
                                  ? colorScheme.primary
                                  : colorScheme.primary.withOpacity(0.3),
                              icon: Icons.lightbulb),
                        ],
                      ),
                    ],
                  ),
                );
              }),
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
}
