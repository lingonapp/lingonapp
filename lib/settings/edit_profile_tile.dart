import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditProfileTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.account_circle),
        title: const Text('Profile'),
        subtitle: const Text('Edit your profile'),
      ),
    );
  }
}
