import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'authentication/bloc/authentication_bloc.dart';
import 'authentication/bloc/authentication_event.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text('Settings'),
        FlatButton(
          child: const Text('Sign out'),
          onPressed:() {
            BlocProvider.of<AuthenticationBloc>(context).dispatch(
              LoggedOut(),
            );
          },
        ),
      ],
    );
  }

}