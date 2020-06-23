import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import './InputFields.dart';

class FormContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return (new Container(
      padding: EdgeInsets.only(top: 20),
      margin: new EdgeInsets.symmetric(horizontal: 100.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          new Form(
              child: new Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Container(
                margin:EdgeInsets.only(bottom: 15),
                child: Text('medicated',style:
                TextStyle(
                  fontFamily: 'Sriracha',
                  fontSize:22,
                  color: Colors.white,
                ),),
              ),
              SizedBox(
                height:60,
                child: new InputFieldArea(
                  hint: "Username",
                  obscure: false,
                  icon: Icons.person_outline,
                ),
              ),
              SizedBox(
                height: 60,
                child: new InputFieldArea(
                  hint: "Password",
                  obscure: true,
                  icon: Icons.lock_outline,
                ),
              ),
            ],
          )),
        ],
      ),
    ));
  }
}
