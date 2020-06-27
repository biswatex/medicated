import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicated/HomeTabs/tab1.dart';
import 'package:medicated/HomeTabs/tab4.dart';

class FragmentHome extends StatelessWidget {
  static const String _title = 'Medicated';
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
      title: _title,
      home: MainClass(),
    );
  }
}
/// Redirect to second class.
class SecondRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}

class MainClass extends StatefulWidget {
  MainClass({Key key}) : super(key: key);
  @override
  _MainClassState createState() => _MainClassState();
}

class _MainClassState extends State<MainClass> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    tabHome(),
    Text(
      'Index 2: School',
    ),
    Text(
      'Index 3: School',
    ),
    User(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child : Scaffold(
          body: Container(
            child: _widgetOptions.elementAt(_selectedIndex),
          ),
          bottomNavigationBar: BubbleBottomBar(
            opacity: .2,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            elevation: 8,
            hasInk: true ,//new, gives a cute ink effect
            inkColor: Colors.black12, //optional, uses theme color if not specified
            items: <BubbleBottomBarItem>[
              BubbleBottomBarItem(backgroundColor: Colors.red, icon: Icon(Icons.home, color: Colors.black,), activeIcon: Icon(Icons.home, color: Colors.red,), title: Text("Home")),
              BubbleBottomBarItem(backgroundColor: Colors.deepPurple, icon: Icon(Icons.local_hospital, color: Colors.black,), activeIcon: Icon(Icons.local_hospital, color: Colors.deepPurple,), title: Text("Clinic")),
              BubbleBottomBarItem(backgroundColor: Colors.indigo, icon: Icon(Icons.timeline, color: Colors.black,), activeIcon: Icon(Icons.timeline, color: Colors.indigo,), title: Text("Track")),
              BubbleBottomBarItem(backgroundColor: Colors.green, icon: Icon(Icons.account_circle, color: Colors.black,), activeIcon: Icon(Icons.account_circle, color: Colors.green,), title: Text("Account"))
            ],
          ),
        ),
    );
  }
}
