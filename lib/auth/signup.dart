import 'package:flutter/material.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.display1,
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
          child: Column(
            children: <Widget>[
              const Text('Sign up page'),
              GestureDetector(
                  child: const Text('App'),
                  onTap: () { Navigator.pushNamed(context, '/app'); }
              )
            ],
          )
      ),
    );
  }
}
