import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../edit_profile_tile.dart';
import '../log_out_tile.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[EditProfileTile(), LogOutTile()],
    );
  }
}
