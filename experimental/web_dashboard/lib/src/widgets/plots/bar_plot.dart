import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:web_dashboard/src/api/api.dart';

import 'package:intl/intl.dart' as intl;

import '../../api/api.dart';
import '../../utils/chart_utils.dart' as utils;

// The number of days to show in the chart
const _daysBefore = 10;

class BarChart extends StatelessWidget {
  final List<Entry> entries;

  BarChart({this.entries});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      [_seriesData()],
      animate: false,
    );
  }

  charts.Series<utils.EntryTotal, String> _seriesData() {
    return charts.Series<utils.EntryTotal, String>(
      id: 'Entries',
      colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.lighter,
      domainFn: (entryTotal, _) {
        if (entryTotal == null) return null;

        var format = intl.DateFormat.Md();
        return format.format(entryTotal.day);
      },
      measureFn: (total, _) {
        if (total == null) return null;

        return total.value;
      },
      data: utils.entryTotalsByDay(entries, _daysBefore),
    );
  }
}
