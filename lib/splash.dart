import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            children: const <Widget>[
              CircularProgressIndicator(),
              Text('Loading')
            ],
          ),
        ),
      ),
    );
  }
}
