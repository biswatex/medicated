import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicated/Screens/Home/tab1.dart';
import 'package:medicated/Screens/Home/Notifications.dart';
import 'package:medicated/components/CustomKFDrawer.dart';

// ignore: must_be_immutable
class FragmentHome extends KFDrawerContent {
  @override
  _MainClassState createState() => _MainClassState();
}

class _MainClassState extends State<FragmentHome>
    with SingleTickerProviderStateMixin {
  int counter = 10;
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
            body: TabHome(),
          ),
        ),
    );
  }
}
