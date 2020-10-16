// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../api/api.dart';
import '../app.dart';
import '../widgets/category_chart.dart';

class DashboardPage extends StatelessWidget {
  Widget build(BuildContext context) {
    var appState = Provider.of<AppState>(context);
    return FutureBuilder<List<Category>>(
      future: appState.api.categories.list(),
      builder: (context, futureSnapshot) {
        if (!futureSnapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return StreamBuilder<List<Category>>(
          initialData: futureSnapshot.data,
          stream: appState.api.categories.subscribe(),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return Dashboard([
              Highlight("Total Sales", "10500", Icons.assignment_rounded),
              Highlight("New Orders", "5043", Icons.receipt_long),
              Highlight("New Users", "1065", Icons.person),
              Highlight("Visitors", "564", Icons.person_add_alt_1),
            ], snapshot.data);
          },
        );
      },
    );
  }
}

class Dashboard extends StatelessWidget {
  final List<Highlight> highlights;
  final List<Category> categories;

  Dashboard(this.highlights, this.categories);

  @override
  Widget build(BuildContext context) {
    var api = Provider
        .of<AppState>(context)
        .api;
    return Scrollbar(
      child: Column(children: [
        GridView(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 2.5,
            crossAxisCount: 4,
          ),
          children: [
            ...highlights.map(
                  (highlight) =>
                  Card(
                    color: Colors.blue[200],
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Row(children: [
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Expanded(
                              child: Container(
                                padding: EdgeInsets.all(12.0),
                                child: LayoutBuilder(builder: (context, constraint) {
                                  return Icon(
                                      highlight.icon, size: constraint.biggest.height * 0.5, color: Colors.white);
                                }),
                                decoration: BoxDecoration(
                                  color: Colors.blue[100],
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                              child: LayoutBuilder(builder: (context, constraint) {
                                return Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                                  Text(highlight.value,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: min(constraint.biggest.height * 0.2, 22),
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text(highlight.name,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: min(constraint.biggest.height * 0.14, 14),
                                      )),
                                ]);
                              }),
                            ),
                          ),
                        )
                      ]),
                    ),
                    margin: EdgeInsets.all(16),
                  ),
            )
          ],
        ),
        Expanded(
          child: GridView(
            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              childAspectRatio: 0.8,
              maxCrossAxisExtent: 500,
            ),
            padding: EdgeInsets.all(12),
            children: [
              ...categories.map(
                    (category) =>
                    Card(
                      child: CategoryChart(category: category, api: api, type: category.type),
                      margin: EdgeInsets.all(16),
                    ),
              )
            ],
          ),
        )
      ]),
    );
  }
}
