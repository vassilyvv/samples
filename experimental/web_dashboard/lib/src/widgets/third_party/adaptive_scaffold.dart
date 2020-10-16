// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';

import '../../app.dart';

bool _isLargeScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > 960.0;
}

bool _isMediumScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > 640.0;
}

/// See bottomNavigationBarItem or NavigationRailDestination
class AdaptiveScaffoldDestination {
  final String title;
  final IconData icon;

  const AdaptiveScaffoldDestination({
    @required this.title,
    @required this.icon,
  });
}

/// A widget that adapts to the current display size, displaying a [Drawer],
/// [NavigationRail], or [BottomNavigationBar]. Navigation destinations are
/// defined in the [destinations] parameter.
class AdaptiveScaffold extends StatefulWidget {
  final Widget title;
  final Widget titleFull;
  final List<Widget> actions;
  final Widget body;
  final int currentIndex;
  final List<AdaptiveScaffoldDestination> destinations;
  final ValueChanged<int> onNavigationIndexChange;
  final FloatingActionButton floatingActionButton;

  AdaptiveScaffold({
    this.title,
    this.titleFull,
    this.body,
    this.actions = const [],
    @required this.currentIndex,
    @required this.destinations,
    this.onNavigationIndexChange,
    this.floatingActionButton,
  });

  @override
  _AdaptiveScaffoldState createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  @override
  Widget build(BuildContext context) {
    // Show a Drawer
    if (_isLargeScreen(context)) {
      return Row(
        children: [
          Theme(
            data: Theme.of(context).copyWith(
              canvasColor: Colors.grey[200], //This will change the drawer background to blue.
              //other styles
            ),
            child: Drawer(
              child: Container(
                padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 16.0),
                child: Column(
                  children: [
                    Container(
                      child: widget.titleFull,
                      padding: EdgeInsets.only(bottom: 24.0),
                    ),
                    for (var d in widget.destinations)
                      ListTileTheme(
                        dense: true,
                        selectedColor: Colors.black,
                        child: ListTile(
                          leading: Icon(d.icon),
                          trailing: widget.destinations.indexOf(d) == 0 ? _notificationCount(NOTIFICATION_COUNT) : null,
                          title: Text(d.title, style: TextStyle(fontSize: 16)),
                          selected: widget.destinations.indexOf(d) == widget.currentIndex,
                          onTap: () => _destinationTapped(d),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Scaffold(
              body: Column(children: [
                Container(
                  child: Align(
                    child: Row(
                      children: widget.actions,
                      mainAxisAlignment: MainAxisAlignment.end,
                    ),
                  ),
                  color: Colors.grey[200],
                  margin: EdgeInsets.all(16.0),
                ),
                Expanded(child: widget.body)
              ]),
              floatingActionButton: widget.floatingActionButton,
            ),
          ),
        ],
      );
    }

    // Show a navigation rail
    if (_isMediumScreen(context)) {
      return Scaffold(
        appBar: AppBar(
          title: widget.title,
          actions: widget.actions,
          backgroundColor: Colors.grey[200],
        ),
        body: Row(
          children: [
            NavigationRail(
              leading: widget.floatingActionButton,
              destinations: [
                ...widget.destinations.map(
                  (d) => NavigationRailDestination(
                    icon: Icon(d.icon),
                    label: Text(d.title),
                  ),
                ),
              ],
              selectedIndex: widget.currentIndex,
              onDestinationSelected: widget.onNavigationIndexChange ?? (_) {},
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: Colors.grey[300],
            ),
            Expanded(
              child: widget.body,
            ),
          ],
        ),
      );
    }

    // Show a bottom app bar
    return Scaffold(
      body: widget.body,
      appBar: AppBar(
        title: widget.title,
        actions: widget.actions,
        backgroundColor: Colors.grey[200],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          ...widget.destinations.map(
            (d) => BottomNavigationBarItem(
              icon: Icon(d.icon),
              title: Text(d.title),
            ),
          ),
        ],
        currentIndex: widget.currentIndex,
        onTap: widget.onNavigationIndexChange,
      ),
      floatingActionButton: widget.floatingActionButton,
    );
  }

  void _destinationTapped(AdaptiveScaffoldDestination destination) {
    var idx = widget.destinations.indexOf(destination);
    if (idx != widget.currentIndex) {
      widget.onNavigationIndexChange(idx);
    }
  }

  Widget _notificationCount(int count) {
    return Container(
      width: 24.0,
      height: 24.0,
      child: Align(
        child: Text(count.toString(), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
        alignment: Alignment.center,
      ),
      decoration: BoxDecoration(
          color: Colors.blue[200],
          borderRadius: BorderRadius.all(const Radius.circular(8.0))),
    );
  }
}
