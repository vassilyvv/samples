// Copyright 2020, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:web_dashboard/src/utils/notifications.dart';

import '../app.dart';
import '../widgets/dialogs.dart';
import '../widgets/third_party/adaptive_scaffold.dart';
import 'dashboard.dart';
import 'entries.dart';

class HomePage extends StatefulWidget {
  final VoidCallback onSignOut;

  HomePage({
    @required this.onSignOut,
  });

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      titleFull: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(children: [
            Container(
              margin: EdgeInsets.all(16.0),
              child: Image(
                image: AssetImage("assets/logo.png"),
                width: 100,
              ),
            ),
            Container(
              margin: EdgeInsets.all(16.0),
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage("assets/avatar.png"),
                ),
              ),
            ),
            Text(
              "Vassily Zuber",
              style: TextStyle(color: Colors.grey[700], fontSize: 18, fontWeight: FontWeight.bold),
            )
          ])),
      title: Text('Dashboard'),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {},
            child: Container(
              // margin: EdgeInsets.all(16.0),
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage("assets/avatar.png"),
                ),
              ),
            ),
          ),
        ),
        InkWell(
          onTap: () {},
          child: Container(
            width: 32,
            height: 32,
            margin: const EdgeInsets.all(8.0),
            alignment: Alignment.center,
            child: Stack(
              children: <Widget>[
                Icon(Icons.notifications, size: 36.0,),
                Positioned(
                  // draw a red marble
                  top: 0.0,
                  right: 0.0,
                  child: Container(
                    padding: EdgeInsets.all(4.0),
                    child: Align(
                      child: Text(
                        trimNotificationCount(NOTIFICATION_COUNT),
                        style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                      alignment: Alignment.center,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.blue[200], borderRadius: BorderRadius.all(const Radius.circular(8.0))),
                  ),
                )
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: FlatButton(
            onPressed: () => _handleSignOut(),
            child: Text('SIGN OUT', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      ],
      currentIndex: _pageIndex,
      destinations: [
        AdaptiveScaffoldDestination(title: 'Home', icon: Icons.home),
        AdaptiveScaffoldDestination(title: 'Entries', icon: Icons.list),
        AdaptiveScaffoldDestination(title: 'Settings', icon: Icons.settings),
      ],
      body: _pageAtIndex(_pageIndex),
      onNavigationIndexChange: (newIndex) {
        setState(() {
          _pageIndex = newIndex;
        });
      },
      floatingActionButton: _hasFloatingActionButton ? _buildFab(context) : null,
    );
  }

  bool get _hasFloatingActionButton {
    if (_pageIndex == 2) return false;
    return true;
  }

  FloatingActionButton _buildFab(BuildContext context) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      onPressed: () => _handleFabPressed(),
    );
  }

  void _handleFabPressed() {
    if (_pageIndex == 0) {
      showDialog<NewCategoryDialog>(
        context: context,
        builder: (context) => NewCategoryDialog(),
      );
      return;
    }

    if (_pageIndex == 1) {
      showDialog<NewEntryDialog>(
        context: context,
        builder: (context) => NewEntryDialog(),
      );
      return;
    }
  }

  Future<void> _handleSignOut() async {
    var shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Are you sure you want to sign out?'),
        actions: [
          FlatButton(
            child: Text('No'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
          FlatButton(
            child: Text('Yes'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      ),
    );

    if (!shouldSignOut) {
      return;
    }

    widget.onSignOut();
  }

  static Widget _pageAtIndex(int index) {
    if (index == 0) {
      return DashboardPage();
    }

    if (index == 1) {
      return EntriesPage();
    }

    return Center(child: Text('Settings page'));
  }
}
