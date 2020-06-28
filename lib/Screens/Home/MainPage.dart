import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicated/Screens/Login/index.dart';
import 'package:medicated/components/DataSearch.dart';
import 'package:medicated/drawerFragments/FragmentAbout.dart';
import 'package:medicated/drawerFragments/FragmentSettings.dart';
import 'package:medicated/drawerFragments/fragmentHome.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DrawerItem {
  String title;
  IconData icon;
  DrawerItem(this.title, this.icon);
}
class HomePage extends StatefulWidget {
  final String title;
  final String uid;
  HomePage({Key key, this.title,this.uid}) : super(key: key);
  final drawerItems = [
    new DrawerItem("Hone", Icons.home),
    new DrawerItem("Settings", Icons.settings),
    new DrawerItem("About", Icons.info)
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {

  int counter = 10;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _selectedDrawerIndex = 0;
  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new FragmentHome();
      case 1:
        return new Settings();
      case 2:
        return new About();

      default:
        return new FragmentHome();
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }
  getSF() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name',widget.title);
    prefs.setString('email', widget.uid);
  }
  @override
  Widget build(BuildContext context) {
    getSF();
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(
          new ListTile(
            leading: new Icon(d.icon,color: Colors.black54,),
            title: new Text(d.title),
            selected: i == _selectedDrawerIndex,
            onTap: () => _onSelectItem(i),
          )
      );
    }
    String name ;
    String uide;
    if(widget.title!=null && widget.uid != null) {
      name = widget.title;
      uide = widget.uid;
    }
    else{
      uide ="1";
      name = "User";
    }
    return Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255,51, 153, 204),
            iconTheme: IconThemeData(color: Colors.white),
            elevation: 0.0,
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.search, color: Colors.white,),
                onPressed: () {
                  showSearch(context: context, delegate: DataSearch());
                },
              ),
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
            ],
          ),
          body: Center(
            child: _getDrawerItemWidget(_selectedDrawerIndex),
          ),
          drawer: new Drawer(
            child:  new Column(
                      children: <Widget>[
                        new UserAccountsDrawerHeader(
                            accountName: new Text(name), accountEmail:Text(uide)),
                        new Column(children: drawerOptions),
                        new RaisedButton(
                          onPressed: () {
                            FirebaseAuth.instance.signOut();
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: const Text('Logout'),
                        ),
                      ],
                    )
          )
    );
  }
}