import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lingon/authentication/bloc/bloc.dart';

class LogOutTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(Icons.exit_to_app),
        title: const Text('Sign out'),
        onTap: () {
          BlocProvider.of<AuthenticationBloc>(context).add(
            LoggedOut(),
          );
        },
      ),
    );
  }
}
