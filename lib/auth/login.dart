import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: Theme.of(context).textTheme.display1,
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            const Text('Login page'),
            GestureDetector(
                child: const Text('Signup'),
                onTap: () { Navigator.pushNamed(context, 'auth/signup'); }
            )
          ],
        )
      ),
    );
  }
}
