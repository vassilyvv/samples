import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:web_dashboard/src/api/api.dart';

import '../../api/api.dart';
import '../../utils/chart_utils.dart' as utils;


// The number of days to show in the chart
const _daysBefore = 10;

class ScatterChart extends StatelessWidget {
  final List<Entry> entries;

  ScatterChart({this.entries});

  @override
  Widget build(BuildContext context) {
    var series = [_seriesData()];
    print("Series type is: ${series.runtimeType}");
    return charts.ScatterPlotChart(
      series,
      animate: false,
    );
  }

  charts.Series<utils.EntryTotal, int> _seriesData() {
    return charts.Series<utils.EntryTotal, int>(
      id: 'Entries',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.lighter,
      domainFn: (entryTotal, _) {
        if (entryTotal == null) return null;

        return entryTotal.day.day;
      },
      measureFn: (total, _) {
        if (total == null) return null;

        return total.value;
      },
      data: utils.entryTotalsByDay(entries, _daysBefore),
    );
  }
}
