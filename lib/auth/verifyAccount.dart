import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyAccountPage extends StatelessWidget {
  // TODO: Add input field for code
  // TODO: Refresh user when authenticated `user.reload()`
  Future<void> _resendEmail() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    if (user == null || user.isEmailVerified) {
      return;
    }
    user.sendEmailVerification();
    print('Sent verification email');
  }

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
              FlatButton(
                  child: const Text('Resend verification email'),
                  onPressed: () {
                    _resendEmail();
                  }),
            ],
          )),
    );
  }
}
