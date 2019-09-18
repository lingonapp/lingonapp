import 'package:flutter/material.dart';

class VerifyAccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.display1,
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              const Text('Verify page'),
              GestureDetector(
                  child: const Text('Home'),
                  onTap: () { Navigator.pushNamed(context, '/'); }
              )
            ],
          )
      ),
    );
  }
}
