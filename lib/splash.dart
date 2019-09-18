import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
        style: Theme.of(context).textTheme.display1,
    child: Container(
      child: const Text('Loading'),
    ),
    );
  }
}
