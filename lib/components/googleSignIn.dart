import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GoogleSignIn extends StatelessWidget {
  final DecorationImage google;
  final DecorationImage facebook;
  GoogleSignIn({this.google,this.facebook});
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Container(
      child: Column(
        children: [
          Container(
            child: Row(
                children: <Widget>[
                  Expanded(
                      child: Divider(
                        indent: 10,
                        endIndent: 10,
                        color: Colors.white,
                        thickness: 1,
                      )
                  ),
                  AutoSizeText('or',
                        maxLines:1,
                        style: TextStyle(color:Colors.white,fontWeight:FontWeight.normal)),
                  Expanded(
                      child: Divider(
                        indent: 10,
                        endIndent: 10,
                        color: Colors.white,
                        thickness: 1,
                      )
                  ),
                ]
            )
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
                padding: EdgeInsets.symmetric(vertical:10),
                width: width*0.25,
                child: AutoSizeText('Continue With',
                    maxLines:1,
                    style: TextStyle(color:Colors.white,fontWeight:FontWeight.normal))),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children:<Widget>[
              Container(
                margin: EdgeInsets.all(5),
              width:width*0.15,
              height:width*0.15,
              alignment: Alignment.center,
              decoration: new BoxDecoration(
                image: google,
              ),
            ),
            Container(
              margin: EdgeInsets.all(5),
              width:width*0.15,
              height:width*0.15,
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
