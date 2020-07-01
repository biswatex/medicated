import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:medicated/components/CategoryCard.dart';
import 'package:medicated/components/PathologyCard.dart';
import 'package:medicated/components/card.dart';
import 'package:medicated/components/mainAppBar.dart';

class TabHome extends StatefulWidget {
  @override
  _TabHomeState createState() => _TabHomeState();

}

class _TabHomeState extends State<TabHome>
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
    //var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            MainAppBar(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.only(left: 20),
                child: Text('Category', style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Sriracha',
                  fontSize: 16,
                  color: Colors.black54,
                ),),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CategoryCard(),
            ),
            Container(
              padding: EdgeInsets.only(left: 20),
              child: Text('Nearby Doctors', style: TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: 'Sriracha',
                fontSize: 16,
                color: Colors.black54,
              ),),
            ),
            Container(
              height: 400,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: DoctorsCard(),
              ),
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
            PathologyCard(),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text('Physiology', style: TextStyle(
                fontWeight: FontWeight.normal,
                fontFamily: 'Sriracha',
                fontSize: 22,
                color: Colors.black54,
              ),),
            ),
            Container(
              padding: EdgeInsets.all(15),
              child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius:BorderRadius.only(topLeft:Radius.circular(25),topRight: Radius.circular(25),bottomRight: Radius.circular(25),bottomLeft: Radius.circular(25))
                  ),
                  elevation: 10,
                  child:Container(
                    height: 300,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/physio.png')),
                      borderRadius: BorderRadius.all(Radius.circular(25.0)),
                      color: Colors.white,
                    ),
                  )
              )
            ),
          ],
        ),
      ),
    );
  }
}