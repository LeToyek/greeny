import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:greenify/model/height_model.dart';
import 'package:greenify/model/pot_model.dart';
import 'package:greenify/states/theme_mode.dart';
import 'package:greenify/utils/date_helper.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:month_year_picker/month_year_picker.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DetailPlantProgressChart extends ConsumerStatefulWidget {
  final PotModel pot;
  const DetailPlantProgressChart({super.key, required this.pot});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailPlantProgressChartState();
}

class _DetailPlantProgressChartState
    extends ConsumerState<DetailPlantProgressChart> {
  String month = DateFormat("MMMM,yyyy").format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    final themeRef = ref.watch(themeProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return Column(children: [
      Text(
        "Grafik Pertumbuhan",
        style: textTheme.headlineSmall!
            .apply(fontWeightDelta: 2, color: colorScheme.onSurface),
      ),
      const SizedBox(height: 10),
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
      const SizedBox(height: 10),
      SfCartesianChart(
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
        series: [getSeries(widget.pot, themeRef)],
      )
    ]);
  }

  SplineAreaSeries getSeries(PotModel pot, ThemeMode themeMode) {
    final colorScheme = Theme.of(context).colorScheme;
    SplineAreaSeries series = SplineAreaSeries<HeightModel, String>(
      borderColor: colorScheme.primary,
      markerSettings: MarkerSettings(
          isVisible: true,
          color: colorScheme.surface,
          borderColor: colorScheme.primary),
      borderWidth: 2,
      gradient: LinearGradient(colors: [
        Colors.greenAccent,
        themeMode == ThemeMode.dark
            ? Colors.green.withOpacity(0.3)
            : Colors.green
      ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
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
    );
    return series;
  }
}
