// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:flutter/material.dart';

import 'package:web_dashboard/src/widgets/plots/bar_plot.dart';
import 'package:web_dashboard/src/widgets/plots/line_plot.dart';
import 'package:web_dashboard/src/widgets/plots/scatter_plot.dart';

import '../api/api.dart';
import 'dialogs.dart';

class CategoryChart extends StatelessWidget {
  final Category category;
  final DashboardApi api;
  final String type;

  CategoryChart({
    @required this.category,
    @required this.api,
    @required this.type,
  });

  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 24.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(category.name, style: TextStyle(color: Colors.black, fontSize: 18)),
                  IconButton(
                    icon: Icon(Icons.settings),
                    onPressed: () {
                      showDialog<EditCategoryDialog>(
                        context: context,
                        builder: (context) {
                          return EditCategoryDialog(category: category);
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(children: [
                    _loadingText((a) => a.map((e) => e.value).reduce((a, b) => a + b).toString()),
                    Text("Total", style: TextStyle(color: Colors.grey[700], fontSize: 16)),
                  ]),
                  Column(children: [
                    _loadingText((a) => a.map((e) => e.value).reduce(max).toString()),
                    Text("Max", style: TextStyle(color: Colors.grey[700], fontSize: 16)),
                  ]),
                  Column(children: [
                    _loadingText((a) => a.map((e) => e.value).reduce(min).toString()),
                    Text("Least", style: TextStyle(color: Colors.grey[700], fontSize: 16)),
                  ]),
                ],
              ),
            ),
            Expanded(
              // Load the initial snapshot using a FutureBuilder, and subscribe to
              // additional updates with a StreamBuilder.
              child: FutureBuilder<List<Entry>>(
                future: api.entries.list(category.id),
                builder: (context, futureSnapshot) {
                  if (!futureSnapshot.hasData) {
                    return _buildLoadingIndicator();
                  }
                  return StreamBuilder<List<Entry>>(
                    initialData: futureSnapshot.data,
                    stream: api.entries.subscribe(category.id),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return _buildLoadingIndicator();
                      }

                      switch (type) {
                        case CHART_TYPE_LINE:
                          return LineChart(entries: snapshot.data);
                        case CHART_TYPE_BAR:
                          return BarChart(entries: snapshot.data);
                        case CHART_TYPE_SCATTER:
                          return ScatterChart(entries: snapshot.data);
                        default:
                          return BarChart(entries: snapshot.data);
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ));
  }

  Widget _buildLoadingIndicator() {
    return Center(child: CircularProgressIndicator());
  }

  Widget _loadingText(String Function(List<Entry> a) fun) {
    return FutureBuilder<List<Entry>>(
      future: api.entries.list(category.id),
      builder: (context, futureSnapshot) {
        if (!futureSnapshot.hasData) {
          return _buildLoadingIndicator();
        }
        return StreamBuilder<List<Entry>>(
            initialData: futureSnapshot.data,
            stream: api.entries.subscribe(category.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return _buildLoadingIndicator();
              }

              return Text(fun(snapshot.data),
                  style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold));
            });
      },
    );
  }
}
