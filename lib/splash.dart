import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.display1,
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              const Text('Splash'),
              GestureDetector(
                  child: const Text('Auth'),
                  onTap: () { Navigator.pushReplacementNamed(context, '/auth'); }
              ),
              GestureDetector(
                  child: const Text('App'),
                  onTap: () { Navigator.pushReplacementNamed(context, '/app'); }
              )
            ],
          )
      ),
    );
  }
}
