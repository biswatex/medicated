import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medicated/components/CategoryCard.dart';
import 'package:medicated/components/card.dart';
import 'package:recase/recase.dart';
import 'package:shared_preferences/shared_preferences.dart';
class tabHome extends StatefulWidget {
  @override
  _tabHomeState createState() => _tabHomeState();

}

class _tabHomeState extends State<tabHome>
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
  Widget build(BuildContext context)  {
    var width = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            AnimatedBuilder(
                animation: _controllerr,
                builder: (BuildContext context, Widget child) {
                  return ClipPath(
            clipper: ClipClass(_controllerr.value),
            child: Container(
              color: Color.fromARGB(255, 51, 153, 204),
              height: 300,
              child: Align(
                alignment: Alignment.topLeft,
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 200,
                      width: width * 0.4,
                      child: ListView(
                        children: <Widget>[
                          Container(padding: EdgeInsets.only(left: 20,),
                              child: Text('Hi,', style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Sriracha',
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
                                      fontFamily: 'Sriracha',
                                      fontSize: 32,
                                      color: Colors.white,),
                                    )
                                )
                                    : Container(
                                    padding: EdgeInsets.only(left: 40,),
                                    child: Text('user', style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Sriracha',
                                      fontSize: 32,
                                      color: Colors.white,),
                                    )
                                );
                              }),
                        ],
                      ),
                    ),
                    Container(
                      width: width * 0.6,
                      height: 200,
                      color: Color.fromARGB(255, 51, 153, 204),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Image(image: AssetImage(
                            'assets/images/doctor_animated.gif'),
                          fit: BoxFit.cover,),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: Text('Category', style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Sriracha',
                  fontSize: 22,
                  color: Colors.black54,
                ),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CategoryCard(),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text('Nearby Doctors', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Sriracha',
                fontSize: 22,
                color: Colors.black54,
              ),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: DoctorsCard(),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text('Pathology', style: TextStyle(
                fontWeight: FontWeight.bold,
                fontFamily: 'Sriracha',
                fontSize: 22,
                color: Colors.black54,
              ),),
            ),
          ],
        ),
      ),
    );
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

