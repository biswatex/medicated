import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GoogleSignIn extends StatelessWidget {
  final DecorationImage google;
  final DecorationImage facebook;
  GoogleSignIn({this.google,this.facebook});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(bottom:50,top: 50),
              child: Text('or',style: TextStyle(color:Colors.white,fontSize:18,fontWeight:FontWeight.bold))),
          Container(
            margin: EdgeInsets.only(bottom:10),
              child: Text('continue with',style: TextStyle(color:Colors.white))),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
              Container(
                margin: EdgeInsets.all(5),
              width: 55.0,
              height: 55.0,
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                image: google,
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
            width: 55.0,
            height: 55.0,
            alignment: Alignment.center,
            decoration: new BoxDecoration(
            image: facebook,
            ),
            ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
