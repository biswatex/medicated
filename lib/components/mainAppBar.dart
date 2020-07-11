import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:recase/recase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainAppBar extends StatefulWidget {
  @override
  _MainAppBarState createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar>
  with SingleTickerProviderStateMixin {
  AnimationController _controllerr;

  @override
  void initState() {
  super.initState();
  _controllerr = AnimationController(
    value: 0.0,
    duration: Duration(seconds: 25),
    upperBound: 1,
    lowerBound: -1,
    vsync: this,
  )..repeat();
  }

  @override
  void dispose() {
  _controllerr.dispose();

  super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    return AnimatedBuilder(
        animation: _controllerr,
        builder: (BuildContext context, Widget child) {
          return ClipPath(
            clipper: ClipClass(_controllerr.value),
            child: Container(
              color: Colors.blue,
              height: MediaQuery.of(context).size.width*0.8,
              child: Align(
                alignment: Alignment.topLeft,
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex:5,
                        child: Container(
                          height: MediaQuery.of(context).size.width*0.6,
                          child: ListView(
                            children: <Widget>[
                              Container(padding: EdgeInsets.only(left: 20,),
                                  child: Text('Hi,', style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Museo',
                                    fontSize: 32,
                                    color: Colors.white,),)
                              ),
                              FutureBuilder<String>(
                                // get the languageCode, saved in the preferences
                                  future: SharedPreferencesHelper.getLanguageCode(),
                                  initialData: 'user',
                                  builder: (BuildContext context,
                                      AsyncSnapshot<String> snapshot) {
                                    return snapshot.hasData
                                        ? Container(
                                        padding: EdgeInsets.only(left: 40,),
                                        child: Text(snapshot.data.sentenceCase, style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Museo',
                                          fontSize: 32,
                                          color: Colors.white,),
                                        )
                                    )
                                        : Container(
                                        padding: EdgeInsets.only(left: 40,),
                                        child: Text('user', style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Museo',
                                          fontSize: 32,
                                          color: Colors.white,),
                                        )
                                    );
                                  }),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex:5,
                        child: Container(
                          height: 300,
                          padding: EdgeInsets.only(right:width*0.1,top:10),
                          decoration: BoxDecoration(
                            image: DecorationImage(image: AssetImage('assets/images/Barbg.png'))
                          ),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Image(image: AssetImage(
                                'assets/images/doctor_animated.gif'),
                              fit: BoxFit.cover,
                            width: width*0.18,),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

class ClipClass extends CustomClipper<Path>{
  double move = 0;
  double slice = math.pi;
  ClipClass(this.move);
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height * 0.8);
    double xCenter =
        size.width * 0.5 + (size.width * 0.6 + 1) * math.sin(move * slice);
    double yCenter = size.height * 0.8 + 69 * math.cos(move * slice);
    path.quadraticBezierTo(xCenter, yCenter, size.width, size.height * 0.8);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;

}
class SharedPreferencesHelper {
  static final String _name = "name";
  static Future<String> getLanguageCode() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return prefs.getString(_name) ?? 'User';
  }
  static Future<bool> setLanguageCode(String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(_name, value);
  }
}


