import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicated/Screens/Login/index.dart';
import 'package:medicated/drawerFragments/FragmentAbout.dart';
import 'package:medicated/drawerFragments/FragmentSettings.dart';
import 'package:medicated/drawerFragments/fragmentHome.dart';
class DrawerItem {
  String title;
  IconData icon;
  String img;
  DrawerItem(this.title, this.icon, this.img);
}
final FirebaseAuth _auth = FirebaseAuth.instance;
class HomePage extends StatefulWidget {
  final drawerItems = [
    new DrawerItem("Fragment 1", Icons.home,'assets/images/appbar_bg.png'),
    new DrawerItem("Fragment 2", Icons.android,'assets/images/appbar_bg.png'),
    new DrawerItem("Fragment 3", Icons.info,'assets/images/appbar_bg.png')
  ];

  @override
  State<StatefulWidget> createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return new FragmentHome();
      case 1:
        return new FlutterBlueApp();
      case 2:
        return new DragabbleScrollableSheetDemo();

      default:
        return new Text("Error");
    }
  }

  _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
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
    return new Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.grey),
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search,color: Colors.grey,),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications,color: Colors.grey,),
            tooltip: 'Next page',
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: _getDrawerItemWidget(_selectedDrawerIndex),
      ),
      drawer: new Drawer(
        child: new Column(
          children: <Widget>[
            new UserAccountsDrawerHeader(

                accountName: new Text("Shantanu pal"), accountEmail: null),
            new Column(children: drawerOptions),
            new IconButton(
              icon: Icon(Icons.brightness_5),
              onPressed: null,
            ),
            new RaisedButton(
              onPressed: (){
                FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}