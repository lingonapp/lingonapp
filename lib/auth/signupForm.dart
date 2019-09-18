import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:validate/validate.dart';

class SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: const SignUpFormState(),
    );
  }
}

class SignUpFormState extends StatefulWidget {
  const SignUpFormState({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpData {
  String email = '';
  String password = '';
}

class _SignUpState extends State<SignUpFormState> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _SignUpData _formData = _SignUpData();

  String _validateEmail(String value) {
    // If empty value, the isEmail function throw a error.
    // So I changed this function with try and catch.
    try {
      Validate.isEmail(value);
    } catch (e) {
      return 'The E-mail Address must be a valid email address.';
    }

    return null;
  }

  String _validatePassword(String value) {
    if (value.length < 6) {
      return 'The Password must be at least 6 characters.';
    }

    return null;
  }

  Future<void> _signUp (String email, String password) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      final FirebaseUser user = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      await user.sendEmailVerification();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(labelText: 'Email'),
              validator: _validateEmail,
              onSaved: (String value) {
                _formData.email = value;
              }),
          TextFormField(
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
              validator: _validatePassword,
              onSaved: (String value) {
                _formData.password = value;
              }),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  _signUp(_formData.email, _formData.password);
                }
              },
              child: const Text('Sign up'),
            ),
          ),
        ],
      ),
    );
  }
}
