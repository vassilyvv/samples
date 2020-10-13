// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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
    return Column(
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
                    case CHART_TYPE_LINE: return LineChart(entries: snapshot.data);
                    case CHART_TYPE_BAR: return BarChart(entries: snapshot.data);
                    case CHART_TYPE_SCATTER: return ScatterChart(entries: snapshot.data);
                    default: return BarChart(entries: snapshot.data);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(child: CircularProgressIndicator());
  }
}
