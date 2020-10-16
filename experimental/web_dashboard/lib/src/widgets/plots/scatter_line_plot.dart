import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:web_dashboard/src/api/api.dart';

import '../../api/api.dart';
import '../../utils/chart_utils.dart' as utils;

// The number of days to show in the chart
const _daysBefore = 8;

class ScatterLineChart extends StatelessWidget {
  final List<Entry> entries;

  ScatterLineChart({this.entries});

  @override
  Widget build(BuildContext context) {
    var series = _seriesData();
    print("Series type is: ${series.runtimeType}");
    return charts.ScatterPlotChart(
      series,
      animate: false,
      customSeriesRenderers: [
        charts.LineRendererConfig(
            // ID used to link series to this renderer.
            customRendererId: 'customLine',
            // Configure the regression line to be painted above the points.
            //
            // By default, series drawn by the point renderer are painted on
            // top of those drawn by a line renderer.
            layoutPaintOrder: charts.LayoutViewPaintOrder.point + 1)
      ],
    );
  }

  List<charts.Series<utils.EntryTotal, int>> _seriesData() {
    return [
      charts.Series<utils.EntryTotal, int>(
        id: 'Entries',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault.darker,
        domainFn: (entryTotal, _) {
          if (entryTotal == null) return null;

          return entryTotal.day.day;
        },
        measureFn: (total, _) {
          if (total == null) return null;

          return total.value;
        },
        data: utils.entryTotalsByDay(entries, _daysBefore),
      ),
      charts.Series<utils.EntryTotal, int>(
        id: 'Line Entries',
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
      )..setAttribute(charts.rendererIdKey, 'customLine'),
    ];
  }
}
