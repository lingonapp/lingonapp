import 'package:flutter/material.dart';
import 'package:lingon/theme.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen({Key key, this.loadingText}) : super(key: key);
  final String loadingText;

  @override
  Widget build(BuildContext context) {
    var text = loadingText == null ? 'Loading' : loadingText;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(color: lingonTheme.primaryColor),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: Text(text, style: TextStyle(color: Colors.white)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
