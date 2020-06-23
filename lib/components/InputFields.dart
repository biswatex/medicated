import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class InputFieldArea extends StatelessWidget {
  final String hint;
  final bool obscure;
  final IconData icon;
  InputFieldArea({this.hint, this.obscure, this.icon});
  @override
  Widget build(BuildContext context) {
    return (new Container(
      margin: EdgeInsets.all(5),
      decoration: new BoxDecoration(
        border: new Border(
          bottom: new BorderSide(
            width: 0.5,
            color: Colors.white24,
          ),
        ),
      ),
      child: new TextFormField(
        obscureText: obscure,
        decoration: new InputDecoration(
          prefixIcon: new Icon(icon,color:Colors.white),
          labelText: hint,
          labelStyle: TextStyle(color: Colors.white),
          fillColor: Colors.white12,
          filled: true,
          border: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: new BorderSide(
              color: Colors.white,
            )),
          focusedBorder: new OutlineInputBorder(
            borderRadius: new BorderRadius.circular(25.0),
            borderSide: new BorderSide(
              color: Colors.white,
            )),
          enabledBorder: new OutlineInputBorder(
              borderRadius: new BorderRadius.circular(25.0),
              borderSide: new BorderSide(
                color: Colors.white,
              )),
        ),
        validator: (val) {
          if(val.length==0) {
            return "Email cannot be empty";
          }else{
            return null;
          }
        },
        keyboardType: TextInputType.emailAddress,
        style: new TextStyle(
          fontFamily: "Poppins",
        ),
      ),
    ));
  }
}
