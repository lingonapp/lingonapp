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
    return ListView(
      children: <Widget>[EditProfileTile(), LogOutTile()],
    );
  }
}
