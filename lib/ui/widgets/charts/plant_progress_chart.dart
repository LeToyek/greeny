import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:greenify/model/height_model.dart';
import 'package:greenify/model/pot_model.dart';
import 'package:greenify/states/home_state.dart';
import 'package:greenify/utils/date_helper.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PlantProgressChart extends ConsumerStatefulWidget {
  const PlantProgressChart({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PlantProgressChartState();
}

class _PlantProgressChartState extends ConsumerState<PlantProgressChart> {
  String month = DateFormat("MMMM,yyyy").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final refPots = ref.watch(homeProvider);
    final notifierPot = ref.read(homeProvider.notifier);

    print('month = $month');
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Container(
      child: Column(
        children: [
          Text(
            "Grafik Pertumbuhan",
            style: textTheme.headlineSmall!
                .apply(fontWeightDelta: 2, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () async {
                    final res = await showMonthYearPicker(
                        context: context,
                        initialMonthYearPickerMode: MonthYearPickerMode.month,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2022),
                        lastDate: DateTime.now());
                    if (res != null) {
                      setState(() {
                        month = DateFormat("MMMM,yyyy").format(res);
                      });
                    }
                  },
                  child: Chip(
                    backgroundColor: colorScheme.primary,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Ionicons.calendar_outline,
                          color: colorScheme.onPrimary,
                          size: textTheme.bodyMedium!.fontSize! * 1.5,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(month,
                            style: textTheme.bodyMedium!.apply(
                              fontWeightDelta: 1,
                              color: colorScheme.onPrimary,
                            )),
                      ],
                    ),
                  )),
              Container(),
              GestureDetector(
                  onTap: () async {
                    showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        backgroundColor: Theme.of(context).colorScheme.surface,
                        content: SizedBox(
                          height: 200,
                          child: SingleChildScrollView(
                            child: Column(children: [
                              Text(
                                'Pilih Garden',
                                style: textTheme.titleMedium!.apply(
                                    fontWeightDelta: 2,
                                    color: colorScheme.onSurface),
                              ),
                              const SizedBox(height: 20),
                              ...notifierPot.getAllGarden().map((garden) {
                                return GestureDetector(
                                  onTap: () {
                                    notifierPot.getNewPots(garden: garden);
                                    context.pop();
                                  },
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 10),
                                      Text(
                                        garden.name,
                                        style: textTheme.bodyMedium!.apply(
                                          fontWeightDelta: 1,
                                          color: colorScheme.onSurface,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Divider(
                                        color: colorScheme.onSurface,
                                      )
                                    ],
                                  ),
                                );
                              }).toList(),
                            ]),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Chip(
                    backgroundColor: colorScheme.primary,
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Ionicons.leaf_outline,
                          color: colorScheme.onPrimary,
                          size: textTheme.bodyMedium!.fontSize! * 1.5,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                            notifierPot.getGarden() != null
                                ? notifierPot.getGarden()!.name
                                : "Garden",
                            style: textTheme.bodyMedium!.apply(
                              fontWeightDelta: 1,
                              color: colorScheme.onPrimary,
                            )),
                      ],
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 10),
          refPots.when(error: (error, stackTrace) {
            return Center(
              child: Text(error.toString()),
            );
          }, loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }, data: (data) {
            return SfCartesianChart(
              legend: Legend(
                  isVisible: true,
                  position: LegendPosition.bottom,
                  overflowMode: LegendItemOverflowMode.wrap),
              tooltipBehavior: TooltipBehavior(
                  enable: true,
                  color: colorScheme.primary,
                  format: 'point.x : point.y cm',
                  textStyle: TextStyle(color: colorScheme.onPrimary)),
              primaryXAxis:
                  CategoryAxis(name: "Hari", title: AxisTitle(text: "Hari")),
              primaryYAxis: NumericAxis(
                  name: "Tinggi (cm)", title: AxisTitle(text: "Tinggi (cm)")),
              series: getSeries(data),
            );
          }),
        ],
      ),
    );
  }

  List<LineSeries> getSeries(List<PotModel> pots) {
    List<LineSeries> series = [];
    print('series $series');
    for (var pot in pots) {
      series.add(LineSeries<HeightModel, String>(
        name: pot.plant.name,
        dataSource: pot.plant.heightStat!
            .where((e) =>
                DateFormat("MMMM,yyyy").format(DateTime.parse(e.date)) == month)
            .toList(),
        xValueMapper: (HeightModel height, _) =>
            DateHelper.getDayFormat(height.date),
        yValueMapper: (HeightModel height, _) {
          return height.height;
        },
      ));
    }
    return series;
  }
}
