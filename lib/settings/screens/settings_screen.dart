import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../edit_profile_tile.dart';
import '../log_out_tile.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({Key key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      bottom: true,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Settings",
              textScaleFactor: 3,
              textAlign: TextAlign.left,
            ),
            Expanded(
              child: ListView(
                children: <Widget>[EditProfileTile(), LogOutTile()],
              ),
            )
          ],
        ),
      ),
    );
  }
}
