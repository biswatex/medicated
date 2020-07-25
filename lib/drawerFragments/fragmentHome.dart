import 'package:auto_size_text/auto_size_text.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicated/HomeTabs/tab1.dart';
import 'package:medicated/HomeTabs/tab4.dart';
import 'package:medicated/NotificationHelper.dart';
import 'package:medicated/Screens/Home/Notifications.dart';
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
  Future<bool> _onBackPressed() {
    if(_scaffoldKey.currentState.isEndDrawerOpen){
      Navigator.of(context).pop();
    }else {
      return showDialog(
        context: context,
        builder: (context) =>
        new AlertDialog(
          title: new Text('Are you sure?'),
          content: new Text('Do you want to exit an App'),
          actions: <Widget>[
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text("NO"),
            ),
            SizedBox(height: 16),
            new FlatButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text("YES"),
            ),
          ],
        ),
      ) ??
          false;
    }
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    return Container(
        child : WillPopScope(
          onWillPop: _onBackPressed,
          child: Scaffold(
            key: _scaffoldKey,
            endDrawer:SafeArea(
              child: Drawer(
                  child: Container(
                    height:MediaQuery.of(context).size.height*0.9,
                    child: ListView(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(Icons.notifications),
                            title:Text("Notifications",maxLines:1,style: TextStyle(fontFamily: 'Museo',color: Colors.grey,fontSize: 22),),
                          ),
                          Container(
                              height:MediaQuery.of(context).size.height*0.85,
                              child: Notifications()),
                        ]
                    ),
                  )
              ),
            ),
            appBar: AppBar(
              backgroundColor: Colors.blue,
              elevation:0,
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
                    new IconButton(icon: Icon(Icons.notifications),
                      onPressed:(){_scaffoldKey.currentState.openEndDrawer();},
                    ),
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
            body: TabHome(),/*Container(
              child: _widgetOptions.elementAt(_selectedIndex),
            ),*/
            /*bottomNavigationBar: BubbleBottomBar(
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
            ),*/
          ),
        ),
    );
  }
}
