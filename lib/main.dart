import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'landingPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MultiProvider(
        providers: [
          StreamProvider<FirebaseUser>.value(
              value: FirebaseAuth.instance.onAuthStateChanged,
          )
        ],
        child: LandingPage(),
      ),
    );
  }
}
