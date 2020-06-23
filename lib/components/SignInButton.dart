import 'package:flutter/material.dart';

class SignIn extends StatelessWidget {
  SignIn();
  @override
  Widget build(BuildContext context) {
    return (new Container(
      width: 320.0,
      height: 60.0,
      alignment: FractionalOffset.center,
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(const Radius.circular(30.0)),
      ),
      child: new Text(
        "Sign In",
        style: new TextStyle(
          color: Colors.purple,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
        ),
      ),
    ));
  }
}
