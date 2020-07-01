import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:medicated/HomeTabs/tab1.dart';
import 'package:medicated/HomeTabs/tab4.dart';
import 'package:medicated/components/CustomKFDrawer.dart';

// ignore: must_be_immutable
class FragmentHome extends KFDrawerContent {
  @override
  _MainClassState createState() => _MainClassState();
}

class _MainClassState extends State<FragmentHome>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  int counter = 10;
  final List<Widget> _widgetOptions = <Widget>[
    TabHome(),
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
          appBar: AppBar(
            elevation: 0,
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: widget.onMenuPressed,
                );
              },
            ),
            actions: <Widget>[
              Stack(
                children: <Widget>[
                  new IconButton(icon: Icon(Icons.notifications), onPressed: () {
                    setState(() {
                      counter = 0;
                    });
                  }),
                  Positioned(
                    right: 10,
                    top: 10,
                    child: new Container(
                      padding: EdgeInsets.all(2),
                      decoration: new BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: BoxConstraints(
                        minWidth: 14,
                        minHeight: 14,
                      ),
                      child: Text(
                        '$counter',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 8,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ]
          ),
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
