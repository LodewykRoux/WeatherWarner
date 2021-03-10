import 'package:flutter/material.dart';
import 'package:weather_warner/services/firebase.dart';
import 'package:weather_warner/shared/shared.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  //Variables
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.blue[900],
          title: Text('Login'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  decoration: textInputDecoration.copyWith(hintText: 'Email'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() => email = value);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: true,
                  decoration:
                      textInputDecoration.copyWith(hintText: 'Password'),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter a valid Password';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    setState(() => password = value);
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //Sign in
                    RaisedButton(
                      color: Colors.lightBlue[400],
                      child: Text(
                        'Sign in',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          final result =
                              await _auth.signInEmailAndPass(email, password);
                          if (result == null) {
                            setState(() =>
                                error = 'Valid Email and Password please');
                          } else {
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        }
                      },
                    ),
                    //Register
                    RaisedButton(
                      color: Colors.lightBlue[400],
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          dynamic result =
                              await _auth.registerEmailAndPass(email, password);
                          if (result == null) {
                            setState(() =>
                                error = 'Valid Email and Password please');
                          }
                        }
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 12,
                ),
                Text(
                  error,
                  style: TextStyle(color: Colors.red, fontSize: 14),
                )
              ],
            ),
          ),
        ));
  }
}
